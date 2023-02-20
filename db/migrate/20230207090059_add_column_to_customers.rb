class AddColumnToCustomers < ActiveRecord::Migration[6.1]
  def change
    add_column :customers, :provider, :string
    add_column :customers, :uid, :string
    add_column :customers, :name, :string
    add_index :customers, :email, unique: true
  end
end
