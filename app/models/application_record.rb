# frozen_string_literal: true

# Default base model for the project
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
