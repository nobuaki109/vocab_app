class Word < ApplicationRecord
    validates :english, presence: true
    validates :japanese, presence: true
    validates :example_sentence, presence: false
    validates :phonetic, presence: false
    validates :audio_url, presence: false
    has_many :study_histories, dependent: :destroy
end
