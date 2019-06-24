# frozen_string_literal: true

class EmptyPagesController < ApplicationController
  def empty_test_list
    render layout: false
  end
end
