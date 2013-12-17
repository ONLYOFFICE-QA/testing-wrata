class AddDetailsToTestList < ActiveRecord::Migration
  def change
    add_column :test_lists, :branch, :string
    add_column :test_lists, :project, :string
  end
end
