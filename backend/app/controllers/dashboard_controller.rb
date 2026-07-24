class DashboardController < ApplicationController
  def show
    render json:{
      today_review_count: today_review_count,
      accuracy: {
        last_7_days: accuracy_for(6.days.ago.beginning_of_day),
        last_30_days: accuracy_for(29.days.ago.beginning_of_day),
      },
      study_streak: study_streak,
      word_status: word_status_counts
    }
  end
  private
  def today_review_count
    StudyHistory.where(
      created_at: Time.zone.today.all_day
    ).count
  end
  def accuracy_for(start_time)
    histories = StudyHistory.where(created_at: start_time..Time.current)
    total_count = histories.count

    return nil if total_count.zero?

    correct_count = histories.where(correct: true).count

    (correct_count.to_f / total_count * 100).round(1)
  end
  def study_streak
    study_dates=StudyHistory.pluck(:created_at).map{ |created_at| created_at.in_time_zone.to_date }.uniq

    current_date =Time.zone.today

    unless study_dates.include?(current_date)
      current_date = current_date.yesterday
    end

    streak = 0

    while study_dates.include?(current_date)
      streak += 1
      current_date = current_date.yesterday
    end

    streak
  end
  def word_status_counts
    counts = {
      mastered: 0,
      learning: 0,
      struggling: 0
    }
    words = Word.includes(:study_histories)
    words.each do |word|
      histories =
        word.study_histories.sort_by do |history|
          [history.created_at, history.id]
        end.reverse

      latest_history = histories.first
      recent_three = histories.first(3)

      if latest_history&.correct == false
        counts[:struggling] += 1
      elsif recent_three.length == 3 && recent_three.all?(&:correct)
        counts[:mastered] +=1
      else 
        counts[:learning] +=1
      end
    end
    counts
  end
  
end
