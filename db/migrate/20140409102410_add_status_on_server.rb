class AddStatusOnServer < ActiveRecord::Migration
  def change
    add_column :servers, :_status, :string, :default => 'normal'
  end
end
