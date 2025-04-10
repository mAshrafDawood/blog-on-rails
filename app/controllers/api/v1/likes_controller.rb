module Api
    module V1
        class LikesController < ApplicationController
            before_action :set_post

            # POST /api/v1/posts/:post_id/like
            def create
                like = @post.likes.build(user: current_user)

                unless like.save
                    return render json: { 
                        success: false,
                        error: like.errors.full_messages.to_sentence 
                    }, status: :unprocessable_entity
                end

                return render json: { 
                    success: true,
                    message: 'Post liked successfully' 
                }, status: :created
                
            end

            # DELETE /api/v1/posts/:post_id/like
            def destroy
                like = @post.likes.find_by(user: current_user)
                unless like 
                    return render json: { 
                        success: false, 
                        message: 'Like not found.' 
                    }, status: :not_found
                end
                like.destroy
                render json: { 
                    success: true, 
                    message: 'Post unliked.' 
                }, status: :ok
               
            end

            private

            def set_post
                @post = Post.find(params[:post_id])
            end
        end
    end
end