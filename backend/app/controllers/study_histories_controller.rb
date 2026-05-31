class StudyHistoriesController < ApplicationController
  def create
    history =StudyHistory.new(study_history_params)
    if history.save
      render json: history, status: :created
    else
      render json: {errors: history.errors.full_messages},status: :unprocessable_entity
    end
  end

  def index
    histories = StudyHistory.all.order(created_at: :desc)
    render json: histories
  end

  private 

  def study_history_params
    params.require(:study_history).permit(:word_id, :correct)
  end
end
