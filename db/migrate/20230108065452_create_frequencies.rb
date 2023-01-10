class CreateFrequencies < ActiveRecord::Migration[6.1]
  def change
    create_table :frequencies do |t|

      t.integer :frequency

      t.timestamps
    end
  end
end
