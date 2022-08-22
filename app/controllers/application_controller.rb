class ApplicationController < ActionController::Base
  include SessionsHelper
  include Pagy::Backend

  before_action :set_locale

  private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def logged_in_user
    return if logged_in?

    flash[:danger] = t ".not_logged"
    store_location
    redirect_to login_url
  end

  def default_url_options
    {locale: I18n.locale}
  end
end
