# frozen_string_literal: true

class ApplicationPresenter
  def initialize(record, view = ActionView::Base.new)
    @record = record
    @view = view
  end

  private

  attr_reader :record, :view

  def url_helpers
    Rails.application.routes.url_helpers
  end
end
