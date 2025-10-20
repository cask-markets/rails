module ClerkHelper
  def clerk_sign_in_url(redirect_url: nil)
    redirect_url ||= root_url
    "#{clerk_frontend_api}/sign-in?redirect_url=#{CGI.escape(redirect_url)}"
  end

  def clerk_sign_up_url(redirect_url: nil)
    redirect_url ||= root_url
    "#{clerk_frontend_api}/sign-up?redirect_url=#{CGI.escape(redirect_url)}"
  end

  def clerk_user_profile_url(redirect_url: nil)
    redirect_url ||= root_url
    "#{clerk_frontend_api}/user?redirect_url=#{CGI.escape(redirect_url)}"
  end

  private

  def clerk_frontend_api
    ENV["CLERK_URL"] || "https://your-instance.clerk.accounts.dev"
  end
end