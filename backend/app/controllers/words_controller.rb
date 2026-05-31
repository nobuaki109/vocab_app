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

  private

  def word_params
    params.require(:word).permit(:english,:japanese,:example_sentence)
  end
end
