class AddLikesCountToPosts < ActiveRecord::Migration[8.0]
    def change
        add_column :posts, :likes_count, :integer, default: 0, null: false

        reversible do |dir|
            dir.up do
                Post.reset_column_information
                Post.find_each do |post|
                Post.update_counters(post.id, likes_count: post.likes.count)
                end
            end
        end

    end
end
