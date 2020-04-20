# frozen_string_literal: true

class RemoveDeprecatedBranchFromStartOptions < ActiveRecord::Migration[6.0]
  def up
    change_table :start_options, bulk: true do |t|
      t.remove :shared_branch
      t.remove :teamlab_api_branch
    end
  end

  def down
    change_table :start_options, bulk: true do |t|
      t.string :shared_branch
      t.string :teamlab_api_branch
    end
  end
end
