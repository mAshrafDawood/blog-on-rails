class ApplicationController < ActionController::API
    
    include JsonWebToken


    before_action :authenticate_request

    private

    def authenticate_request
        header = request.headers['Authorization']
        token = header.split(' ').last if header
        decoded = jwt_decode(token)
        unless decoded
            render json: { error: 'Invalid or expired token' }, status: :unauthorized
        end
        
        @current_user = User.find(decoded[:user_id])
        Rails.logger.info( "Current user: #{@current_user[:email]}")

    rescue ActiveRecord::RecordNotFound => e
        return render json: { error: 'User not found' }, status: :unauthorized
    rescue JWT::DecodeError => e
        return render json: { error: "Token decode error: #{e.message}" }, status: :unauthorized
    rescue => e 
        return render json: { error: "Authentication error: #{e.message}" }, status: :unauthorized
    end

    attr_reader :current_user

end
