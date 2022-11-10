# frozen_string_literal: true

# A queue of spec which belong to current user
class TestList < ApplicationRecord
  belongs_to :client
  has_many :test_files

  validates :name, presence: true,
                   length: { minimum: 3, maximum: 20 }

  # Destroy Test List with client cleanup
  # @param [Client] client - client to be deleted
  # @return [Void]
  def destroy_with_client_cleanup(client)
    if client.test_lists.find_by(id:) == self
      test_files.each(&:destroy)
      destroy
    end
    Runner::Application.config.delayed_runs&.delete_runs_by_testlist_name(client, name)
  end
end
