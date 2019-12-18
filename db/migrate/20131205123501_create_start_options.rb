# frozen_string_literal: true

class CreateStartOptions < ActiveRecord::Migration[4.2]
  def change
    create_table :start_options do |t|
      t.string :docs_branch
      t.string :teamlab_branch
      t.string :shared_branch
      t.string :teamlab_api_branch
      t.string :portal_type
      t.string :portal_region
      t.text :start_command

      t.timestamps
    end
  end
end
