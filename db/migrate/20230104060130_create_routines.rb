class CreateRoutines < ActiveRecord::Migration[6.1]
  def change
    create_table :routines do |t|

      t.string :target,            null: false, default: ""
      t.boolean :public_status,    null: false, default: true
      t.integer :customer_id,      null: false
      t.timestamps
    end
  end
end
