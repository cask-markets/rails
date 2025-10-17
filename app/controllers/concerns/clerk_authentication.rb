module ClerkAuthentication
  extend ActiveSupport::Concern

  included do
    helper_method :current_user, :user_signed_in?
  end

  private

  def current_user
    return @current_user if defined?(@current_user)

    @current_user = begin
      clerk_user_id = clerk_session_user_id
      return nil unless clerk_user_id

      User.find_by(clerk_user_id: clerk_user_id)
    rescue => e
      Rails.logger.error "Clerk authentication error: #{e.message}"
      nil
    end
  end

  def user_signed_in?
    current_user.present?
  end

  def require_authentication
    unless user_signed_in?
      redirect_to root_path, alert: "You must be signed in to access this page."
    end
  end

  def clerk_session_user_id
    # Get the session token from the __session cookie (Clerk's default)
    session_token = cookies["__session"]
    return nil unless session_token

    # Verify the session token with Clerk
    begin
      verified_token = Clerk::SDK.decode_token(session_token)
      verified_token["sub"] # Clerk user ID is in the "sub" claim
    rescue JWT::DecodeError => e
      Rails.logger.error "Failed to decode Clerk token: #{e.message}"
      nil
    end
  end
end