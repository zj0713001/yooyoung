module ActiveRecord
  module Remarkable
    extend ActiveSupport::Concern

    module ClassMethods
      def act_as_remark(fields)
        fields.each do |field|
          class_exec do
            has_one field, -> { where target_column: field }, as: :target, class_name: Remark
            default_value_for field do
              Remark.new(target_column: field)
            end
            accepts_nested_attributes_for field, allow_destroy: true, reject_if: Proc.new { |attributes| attributes['content'].blank? }
          end
        end
      end
    end
  end
end
