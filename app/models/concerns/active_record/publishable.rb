module ActiveRecord
  module Publishable
    extend ActiveSupport::Concern

    included do
      scope :published, -> { where published: true }
      scope :unpublished, -> { where published: false }
      before_save :set_published_at
    end

    def publish
      return true if self.published
      self.update_attributes published: true, published_at: Time.now
    end

    def publish!
      return true if self.published
      self.update_attributes! published: true, published_at: Time.now
    end

    def unpublish
      return true unless self.published
      self.update_attributes published: false, published_at: Time.now
    end

    def unpublish!
      return true unless self.published
      self.update_attributes! published: false, published_at: Time.now
    end

    private
    def set_published_at
      if self.published_changed?
        self.published_at = Time.now if self.published
        self.unpublished_at = Time.now unless self.published
      end
    end
  end
end
