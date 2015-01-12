module ActiveRecord
  module SoftDeletable
    extend ActiveSupport::Concern

    included do
      scope :active, -> { where active: true }
      acts_as_paranoid
      before_destroy :before_soft_destroy
      before_restore :before_soft_restore
    end

    private

    def before_soft_destroy
      self.update_attributes active: false
    end

    def before_soft_restore
      self.update_attributes active: true
    end
  end
end
