class CreateStudyHistories < ActiveRecord::Migration[8.1]
  def change
    create_table :study_histories do |t|
      t.references :word, null: false, foreign_key: true
      t.boolean :correct

      t.timestamps
    end
  end
end
