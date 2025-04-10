module Api
    module V1
        class CommentsController < ApplicationController
            before_action :set_post

            # GET /api/v1/posts/:post_id/comments
            def index
                @comments = @post.comments.includes(:user)
                return render json: @comments.as_json(
                    include: {
                        user: {
                            only: [:name],
                            methods: [:image_url]
                        }
                    }
                )
            end

            # POST /api/v1/posts/:post_id/comments
            def create
                @comment = @post.comments.build(comment_params)
                @comment.user = current_user

                unless @comment.save
                    return render json: @comment.errors, status: :unprocessable_entity
                end

                return render json: @comment.as_json(
                    include: {
                        user: {
                            only: [:name],
                            methods: [:image_url]
                        }
                    },
                    except: [:post_id, :user_id]
                )

            end

            # DELETE /api/v1/posts/:post_id/comments/:id
            def destroy
                @comment = @post.comments.find(params[:id])
                unless @comment.user == current_user
                    return render json: { error: 'You are not authorized to delete this comment' }, status: :forbidden
                end

                @comment.destroy
                head :no_content
            end

            # PATCH/PUT /api/v1/posts/:post_id/comments/:id
            def update
                @comment = @post.comments.find(params[:id])
                unless @comment.user == current_user
                    return render json: { error: 'You are not authorized to update this comment' }, status: :forbidden
                end
                unless @comment.update(comment_params)
                    return render json: @comment.errors, status: :unprocessable_entity
                end
                return render json: @comment.as_json(
                    include: {
                        user: {
                            only: [:name],
                            methods: [:image_url]
                        }
                    }
                )
                
            end
                    

            private

            def set_post
                @post = Post.find(params[:post_id])
            end

            def comment_params
                params.require(:comment).permit(:body)
            end
        end
    end
end