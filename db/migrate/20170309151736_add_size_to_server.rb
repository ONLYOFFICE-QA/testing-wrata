class AddSizeToServer < ActiveRecord::Migration[5.0]
  def change
    add_column :servers, :size, :string
  end
end
