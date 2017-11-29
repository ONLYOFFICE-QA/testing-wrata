class CreateTestedServers < ActiveRecord::Migration[5.1]
  def change
    create_table :tested_servers do |t|
      t.string :url

      t.timestamps
    end
  end
end
