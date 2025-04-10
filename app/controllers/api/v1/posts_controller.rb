module Api
    module V1
      class PostsController < ApplicationController
        before_action :set_post, only: [:show, :update, :destroy]
        before_action :check_owner, only: [:update, :destroy]


        # GET /api/v1/posts
        def index
            @posts = Post.includes(:author, :tags).all
            render json: @posts.as_json(
                methods: [:likes_count],
                include: {
                    author: { 
                        only: [:name, :created_at], 
                        methods: [:image_url] 
                    },
                    tags: {}
                },
                except: [:user_id, :body]
            ), status: :ok
        end

        # GET /api/v1/posts/:id
        def show
            render json: @post.as_json(
                methods: [:likes_count],
                include: {
                    author: { 
                        only: [:name, :created_at], 
                        methods: [:image_url] 
                    },
                    tags: {}
                },
                except: [:user_id]
            )
        end

        # POST /api/v1/posts
        def create
            # Note: current_user is provided by your auth system.
            @post = current_user.posts.build(post_params)

            unless @post.save
                render json: @post.errors, status: :unprocessable_entity
            end

            return render json: @post.as_json(
                methods: [:likes_count],
                include: {
                    author: { 
                        only: [:name, :created_at], 
                        methods: [:image_url] 
                    },
                    tags: {}
                },
                except: [:user_id]
            ), status: :created
        end

        # PATCH/PUT /api/v1/posts/:id
        def update
            unless @post.update(post_params)
                render json: @post.errors, status: :unprocessable_entity
            end
            return render json: @post.as_json(
                methods: [:likes_count],
                include: {
                    author: { 
                        only: [:name, :created_at],
                        methods: [:image_url]
                    },
                    tags: {}
                },
                except: [:user_id]
            ), status: :ok 
        end

        # DELETE /api/v1/posts/:id
        def destroy
            @post.destroy
            head :no_content
        end

        private 

        def set_post
            @post = Post.includes(:author, :tags).find(params[:id])
        end
    
        # Only allow the owner of the post to update or delete it.
        def check_owner
            unless current_user && @post.author == current_user
                return render json: { error: "Unauthorized" }, status: :unauthorized
            end
            return true
        end
    
        def post_params
            # We only permit title and body; author is set automatically.-
            params.require(:post).permit(:title, :body, tags_attributes: [:id, :body, :_destroy])
        end

      end
    end
  end