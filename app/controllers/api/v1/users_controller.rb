module Api
    module V1
        class UsersController < ApplicationController
            skip_before_action :authenticate_request, only: [:create]

            # POST /api/v1/register
            def create
                user = User.new(user_params)
                unless user.save
                    return render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
                end

                return render json: { user: user_data(user), message: 'User created successfully.' }, status: :created
               
            end

            private

            def user_params
                params.require(:user).permit(:name, :email, :password, :password_confirmation, :image)
            end

            # Helper to structure user data in response (excluding password_digest)
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