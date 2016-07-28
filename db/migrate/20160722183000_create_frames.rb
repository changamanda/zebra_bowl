class CreateFrames < ActiveRecord::Migration[5.0]
  def change
    create_table :frames do |t|
      t.integer :frame_number
      t.integer :first_throw
      t.integer :second_throw
      t.integer :third_throw
      t.integer :score
      t.integer :cumulative_score
      t.references :player, foreign_key: true

      t.timestamps
    end
  end
end
