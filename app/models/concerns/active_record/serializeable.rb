module ActiveRecord
  module Serializeable
    extend ActiveSupport::Concern

    module ClassMethods
      def serialize_fields(fields, target = Array, &block)
        fields.each do |field|
          class_exec do
            serialize field, target
            default_value_for field, target.new
            before_save do
              block.call(self[field]) if block
            end
          end
        end
      end
    end
  end
end
