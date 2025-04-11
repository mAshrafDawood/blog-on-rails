class Post < ApplicationRecord
    belongs_to :author, class_name: 'User', foreign_key: 'user_id'
    has_many :tags, dependent: :destroy
    has_many :likes, dependent: :destroy
    has_many :likers, through: :likes, source: :user
    has_many :comments, dependent: :destroy

    after_create :schedule_post_deletion

    accepts_nested_attributes_for  :tags, allow_destroy: true

    validates :title, presence: true
    validates :body, presence: true
    validate :must_have_at_least_one_tag

    def likes_count
        likes.size
    end

    private

    def must_have_at_least_one_tag
        if tags.reject(&:marked_for_destruction?).empty?
            errors.add(:tags, "must have at least one tag")
        end
    end    

    def schedule_post_deletion
        PostDeletionJob.set(wait: 24.hours).perform_later(id)
    end
end
