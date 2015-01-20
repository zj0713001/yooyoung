module ActiveRecord
  module Friendlyable
    extend ActiveSupport::Concern

    module ClassMethods
      def friendlyable(field = :name, slugged = :slugged)
        reflash_method_name = "reflash_#{field}_#{slugged}"
        define_method reflash_method_name do
          self[slugged] = nil if self.changes.keys.include?(field)
        end

        class_exec do
          extend FriendlyId
          friendly_id field, use: slugged
          before_save reflash_method_name
        end
      end
    end
  end
end
