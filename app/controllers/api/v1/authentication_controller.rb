module Api
    module V1
        class AuthenticationController < ApplicationController
            skip_before_action :authenticate_request, only: [:login]

            # POST /api/v1/login
            def login
                user = User.find_by(email: params[:email])

                unless user&.authenticate(params[:password])
                    reutrn render json: { error: 'Invalid email or password' }, status: :unauthorized
                end

                token = jwt_encode({ user_id: user.id })
                return render json: { 
                    token: token, 
                    user: user_data(user), 
                    message: 'Login successful.' 
                }, status: :ok
            end

            # POST /api/v1/logout
            # Note: JWT is stateless. True server-side logout requires a token blocklist (e.g., in Redis or DB).
            # This endpoint is often just a convention for the client to know it should discard the token.
            # For simplicity, this endpoint doesn't *do* anything server-side for now.
            # Currently, I am using it to verify the validy of tokens
            def logout
                return render json: { message: 'Logout successful. Please discard the token client-side.' }, status: :ok
            end

            private

            # Helper to structure user data in response (excluding password_digest)
            # Duplicated from UsersController - could be moved to a helper or concern
            def user_data(user)
                image_url = user.image.attached? ? Rails.application.routes.url_helpers.rails_blob_url(user.image, only_path: true) : nil
                return { 
                    id: user.id, 
                    name: user.name, 
                    email: user.email, 
                    image: image_url, 
                    created_at: user.created_at 
                }
            end

        end
    end
end