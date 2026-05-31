class QuizzesController < ApplicationController
  def show
    word = Word.order("RANDOM()").first
    if word
      render json: word
    else
      render json: {error: "No words available"}, status: :not_found
    end
  end
end
