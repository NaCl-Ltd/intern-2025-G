class Micropost < ApplicationRecord
  belongs_to :user

  has_one_attached :image do |attachable|
    attachable.variant :display, resize_to_limit: [500, 500]
  end

  has_many :favorites, dependent: :destroy
  has_many :favorited_by, through: :favorites, source: :user

  default_scope -> { order(created_at: :desc) }


  scope :following, ->(user) { where(user: user.following) }
  scope :latest, ->(user) { following(user).where("created_at >= ?", 2.days.ago).order(created_at: :desc).limit(10) }
  scope :search_by_content, ->(keyword) {
    where("content LIKE ?", "%#{sanitize_sql_like(keyword)}%") if keyword.present?
  }

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :image,
            content_type: { in: %w[image/jpeg image/gif image/png],
                            message: "must be a valid image format" },
            size: { less_than: 5.megabytes,
                    message: "should be less than 5MB" }

  def favorited?(user)
    favorites.where(user_id: user.id).exists?
  end
end