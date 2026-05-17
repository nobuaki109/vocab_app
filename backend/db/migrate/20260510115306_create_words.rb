class CreateWords < ActiveRecord::Migration[8.1]
  def change
    create_table :words do |t|
      t.string :english
      t.string :japanese
      t.text :example_sentence

      t.timestamps
    end
  end
end
