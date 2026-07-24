class AddPronunciationToWords < ActiveRecord::Migration[8.1]
  def change
    add_column :words, :phonetic, :string
    add_column :words, :audio_url, :string
  end
end
