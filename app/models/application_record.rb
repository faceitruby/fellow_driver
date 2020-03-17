# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def present(context = ApplicationController.renderer)
    return self unless presenter_class

    @present ||= presenter_class.new(self, context)
  end

  private

  def presenter_class
    nil
  end
end
