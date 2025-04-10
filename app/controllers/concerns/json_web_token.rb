require 'jwt'

module JsonWebToken
    extend ActiveSupport::Concern

    SECRET_KEY = ENV['BLOG_ON_RAILS_JWT_SECRET_KEY'] || Rails.application.secret_key_base

    def jwt_encode(payload, exp=72.hours.from_now)
        payload[:exp] = exp.to_i
        JWT.encode(payload, SECRET_KEY)
    end

    def jwt_decode(token)
        decoded = JWT.decode(token, SECRET_KEY)[0]
        HashWithIndifferentAccess.new decoded
    rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
        Rails.logger.error("JWT Error: #{e.message}")
        nil
    end
    

end