class AddServerLastTestFinished < ActiveRecord::Migration[4.2]
  def change
    add_column :servers, :last_test_run_date, :datetime
  end
end
