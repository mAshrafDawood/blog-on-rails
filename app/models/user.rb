class User < ApplicationRecord
    has_secure_password
    has_one_attached :image
    has_many :posts, foreign_key: 'user_id', dependent: :destroy
    has_many :liked_posts, through: :likes, source: :post
    has_many :comments, dependent: :destroy

    validates :name, presence: true
    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :password, presence: true, length: { minimum: 6 }, if: :password_required?
    validates :password_confirmation, presence: true, if: :password_required?

    before_save :downcase_email

    def downcase_email
        self.email = email.downcase
    end

    private

    def password_required?
        new_record? || !password.nil?
    end

    def image_url
        image.attached? ? Rails.application.routes.url_helpers.rails_blob_url(image, only_path: true) : nil
      end

end
