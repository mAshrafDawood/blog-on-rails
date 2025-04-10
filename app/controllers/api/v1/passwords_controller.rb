module Api
    module V1
        class PasswordsController < ApplicationController  
            # PUT /api/v1/change_password
            def update
                unless current_user.authenticate(params[:old_password])
                    return render json: { error: 'Incorrect old password' }, status: :unauthorized
                end
                unless current_user.update(password_params)
                    return render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
                end
                return render json: { message: 'Password updated successfully.' }, status: :ok
            end

            private

            def password_params
                params.permit(:password, :password_confirmation)
            end
        end
    end
end