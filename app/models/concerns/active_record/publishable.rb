module ActiveRecord
  module Publishable
    extend ActiveSupport::Concern

    included do
      scope :published, -> { where published: true }
      scope :unpublished, -> { where published: false }
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
  end
end
