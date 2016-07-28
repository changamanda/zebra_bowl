class CreatePlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :players do |t|
      t.integer :total_score
      t.integer :frame_number

      t.timestamps
    end
  end
end
