Clerk.configure do |c|
  c.secret_key = ENV.fetch("CLERK_SECRET_KEY", nil)
  c.publishable_key = ENV.fetch("CLERK_PUBLISHABLE_KEY", nil)

  # Optionally configure additional settings
  # c.base_url = "https://api.clerk.com"
  # c.logger = Rails.logger
end