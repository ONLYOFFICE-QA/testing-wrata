class AddColumnInServer < ActiveRecord::Migration
  def change
    add_column :servers, :book_client_id, :integer
  end
end
