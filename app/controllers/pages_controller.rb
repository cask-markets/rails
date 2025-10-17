class PagesController < ApplicationController
  def home
  end

  def sign_in
    # Redirect to home if already signed in
    redirect_to root_path if user_signed_in?
  end

  def sign_up
    # Redirect to home if already signed in
    redirect_to root_path if user_signed_in?
  end
end
