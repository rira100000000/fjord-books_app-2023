# frozen_string_literal: true

class ApplicationController < ActionController::Base
  around_action :switch_locale

  def switch_locale(&action)
    locale = cookies[:language] ? cookies[:language].to_sym : I18n.default_locale
    I18n.with_locale(locale, &action)
  end
end
