class Post < ApplicationRecord
  # mount_uploader :cover_image, PhotoUploader

  belongs_to :user
  has_many :comments
  has_one  :post_category

  enum status: %i(upcoming published rejected)

  validates :slug, uniqueness: true, if: Proc.new { |post| post.slug.present? }
  validates :title, :summary, :body, presence: true

  counter :hits

  before_save :generate_summary
  before_create :generate_published_at
  before_validation :safe_slug

  paginates_per 10

  def to_param
    self.slug.blank? ? self.id : self.slug
  end

  def self.find_by_slug!(slug)
    Post.find_by(slug: slug) || Post.find_by(id: slug) || raise(ActiveRecord::RecordNotFound.new(slug: slug))
  end

  def published_at
    super || self.updated_at
  end

  def published!
    self.update(published_at: Time.now)
    super
    if self.user_id
      Notification.create(notify_type: 'press_published',
                          user_id: self.user_id,
                          target: self)
    end
  end

  def cover_image_url
    unless self.cover_image.to_s.start_with?('http')
      '//' + self.cover_image
    end
    self.cover_image
  end

  private

  def safe_slug
    self.slug.downcase!
    self.slug.gsub!(/[^a-z0-9]/i, '-')
  end

  def generate_published_at
    self.published_at = Time.now
  end

  def generate_summary
    if self.summary.blank?
      self.summary = self.body.split("\n").first(10).join("\n")
    end
  end
end
