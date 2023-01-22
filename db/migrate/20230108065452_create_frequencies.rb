class CreateFrequencies < ActiveRecord::Migration[6.1]
  def change
    create_table :frequencies do |t|
      t.integer :routine_id,        null: false
      t.integer :frequency,         null: false
      t.time :reset_time,       null: false

      t.timestamps
    end
  end
end
