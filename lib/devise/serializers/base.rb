require 'devise/strategies/base'

module Devise
  module Serializers
    module Base
      include Devise::Strategies::Base
      attr_reader :scope

      def serialize(record)
        record.class.send(:"serialize_into_#{serialization_type}", record)
      end

      def deserialize(keys)
        mapping.to.send(:"serialize_from_#{serialization_type}", keys)
      end

      def fetch(scope)
        @scope = scope
        super
      end

      def serialization_type
        @serialization_type ||= begin
          warden = self.class.ancestors.find{ |k| k < Warden::Serializers::Base && k != self.class }
          warden.name.split("::").last.underscore
        end
      end
    end
  end
end
