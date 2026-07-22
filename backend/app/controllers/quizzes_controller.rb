class QuizzesController < ApplicationController
  def show
    if params[:mode] == "review"
      word=review_word
      unless word
        render json:{
          error: "No review words available"
        }, status: :not_found
        return
      end
    else
      word=Word.order("RANDOM()").first
    end

    if word
      render json: word
    else
      render json: {error: "No words available"}, status: :not_found
    end
  end

  private

  def review_word
    words = Word.includes(:study_histories)

    review_words = words.select do |word|
      latest_history = word.study_histories.max_by do |history|
        [history.created_at, history.id]
      end
      latest_history&.correct == false
    end

    review_words.max_by do |word|
      word.study_histories.count do |history|
        history.correct == false
      end
    end
  end
end
