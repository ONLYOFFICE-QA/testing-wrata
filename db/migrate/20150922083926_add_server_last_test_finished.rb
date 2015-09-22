class AddServerLastTestFinished < ActiveRecord::Migration
  def change
    add_column :servers, :last_test_run_date, :datetime
  end
end
