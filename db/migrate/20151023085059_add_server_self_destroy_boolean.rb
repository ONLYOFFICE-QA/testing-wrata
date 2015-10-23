class AddServerSelfDestroyBoolean < ActiveRecord::Migration
  def change
    add_column :servers, :self_destruction, :boolean, default: true
  end
end
