module ActiveRecord
  module Friendlyable
    extend ActiveSupport::Concern

    module ClassMethods
      def friendlyable(field = :name)
        class_exec do
          extend FriendlyId
          friendly_id field, use: :slugged
          def should_generate_new_friendly_id?
            true
          end
        end
      end
    end
  end
end
