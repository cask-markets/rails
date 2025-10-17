module Webhooks
  class ClerkController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :verify_webhook_signature

    def create
      case webhook_type
      when "user.created", "user.updated"
        handle_user_upsert
      when "user.deleted"
        handle_user_deletion
      else
        Rails.logger.info "Unhandled Clerk webhook type: #{webhook_type}"
      end

      head :ok
    rescue => e
      Rails.logger.error "Clerk webhook error: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      head :unprocessable_entity
    end

    private

    def handle_user_upsert
      user_data = webhook_data["data"]
      user = User.find_or_initialize_by(clerk_user_id: user_data["id"])

      user.update!(
        email: user_data["email_addresses"]&.first&.dig("email_address"),
        name: [user_data["first_name"], user_data["last_name"]].compact.join(" ").presence || user.email || "User"
      )

      Rails.logger.info "Synced Clerk user #{user.clerk_user_id}"
    end

    def handle_user_deletion
      user_data = webhook_data["data"]
      user = User.find_by(clerk_user_id: user_data["id"])

      if user
        user.destroy!
        Rails.logger.info "Deleted user #{user.clerk_user_id}"
      end
    end

    def verify_webhook_signature
      # Get the webhook secret from environment
      webhook_secret = ENV["CLERK_WEBHOOK_SECRET"]

      unless webhook_secret
        Rails.logger.error "CLERK_WEBHOOK_SECRET not configured"
        head :unauthorized
        return
      end

      # Get the Svix headers
      svix_id = request.headers["svix-id"]
      svix_timestamp = request.headers["svix-timestamp"]
      svix_signature = request.headers["svix-signature"]

      unless svix_id && svix_timestamp && svix_signature
        Rails.logger.error "Missing Svix headers"
        head :unauthorized
        return
      end

      # Verify the webhook using Clerk's webhook verification
      # Note: You may need to add the svix gem for full verification
      # For now, we'll do basic verification
      begin
        # Read the raw body
        body = request.body.read
        request.body.rewind

        # Clerk uses Svix for webhook signing
        # The signature is in the format: v1,signature1 v1,signature2
        # We need to verify at least one signature matches

        expected_signature = compute_signature(webhook_secret, svix_id, svix_timestamp, body)
        signatures = svix_signature.split(" ")

        unless signatures.any? { |sig| secure_compare(sig.split(",").last, expected_signature) }
          Rails.logger.error "Invalid webhook signature"
          head :unauthorized
          return
        end
      rescue => e
        Rails.logger.error "Webhook verification error: #{e.message}"
        head :unauthorized
      end
    end

    def compute_signature(secret, msg_id, msg_timestamp, body)
      to_sign = "#{msg_id}.#{msg_timestamp}.#{body}"
      OpenSSL::HMAC.hexdigest("SHA256", secret, to_sign)
    end

    def secure_compare(a, b)
      return false if a.nil? || b.nil? || a.bytesize != b.bytesize
      l = a.unpack("C*")
      r = 0
      i = -1
      b.each_byte { |byte| r |= byte ^ l[i += 1] }
      r == 0
    end

    def webhook_type
      webhook_data["type"]
    end

    def webhook_data
      @webhook_data ||= JSON.parse(request.body.read).tap { request.body.rewind }
    end
  end
end