require "net/http"
require "json"
class WordsController < ApplicationController
  def index
    words = Word.all.order(created_at: :desc)
    render json: words
  end
  
  def create
    word = Word.new(word_params)
    if word.save
      render json: word, status: :created
    else
      render json: {errors: word.errors.full_messages},status: :unprocessable_entity
    end
  end

  def destroy
    word = Word.find(params[:id])
    if word.destroy
      head :no_content
    else
      render json: {errors: word.errors.full_messages},status: :unprocessable_entity
    end
  end

  def update
    word = Word.find(params[:id])
    if word.update(word_params)
      render json: word
    else 
     render json: {errors: word.errors.full_messages},status: :unprocessable_entity
    end
  end

  def lookup
    english = params[:english].to_s.strip

    if english.blank?
      render json: { errors: ["英単語を入力してください"] }, status: :unprocessable_entity
      return
    end
    dictionary_data = fetch_dictionary(english)
    japanese = fetch_translation(english)

    render json: {
      english: english,
      japanese:japanese,
      example_sentence: dictionary_data[:example_sentence],
      phonetic: dictionary_data[:phonetic],
      audio_url: dictionary_data[:audio_url]
    }
  end

  private

  def word_params
    params.require(:word).permit(:english,:japanese,:example_sentence,:phonetic,:audio_url)
  end


  def fetch_dictionary(english)
    uri = URI("https://api.dictionaryapi.dev/api/v2/entries/en/#{URI.encode_www_form_component(english)}")
    response = Net::HTTP.get_response(uri)

    return {
      example_sentence: "",
      phonetic: "",
      audio_url: ""
    } unless response.is_a?(Net::HTTPSuccess)

    data = JSON.parse(response.body)
    definitions = data.first["meanings"].flat_map {|meaning| meaning["definitions"] }
    example = definitions.find {|definition| definition["example"].present? }
    entry = data.first
    phonetics= Array(entry["phonetics"])
    audio_phonetic = phonetics.find do |phonetic|
      phonetic["audio"].present?
    end
    phonetic =
      audio_phonetic&.dig("text").presence ||
      entry["phonetic"].to_s
    audio_url = audio_phonetic&.dig("audio").to_s
    if audio_url.start_with?("//")
      audio_url = "https:#{audio_url}"
    end
    {
      example_sentence: example&.dig("example").to_s,
      phonetic: phonetic,
      audio_url: audio_url
    }
  end

  def fetch_translation(english)
    uri=URI("https://api.mymemory.translated.net/get")
    uri.query =URI.encode_www_form(
      q: english,
      langpair: "en|ja"
    )
    response = Net::HTTP.get_response(uri)
    return "" unless response.is_a?(Net::HTTPSuccess)

    data = JSON.parse(response.body)
    data.dig("responseData", "translatedText").to_s
  end
end
