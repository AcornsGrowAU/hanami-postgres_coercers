require 'hanami/model/coercer'

module Hanami
  module PostgresCoercers
    class PgArray < Hanami::Model::Coercer
      def self.type(type)
        @type = type
      end

      def self.dump(value)
        return ::Sequel.pg_array(value, @type)
      end

      def self.load(value)
        res = nil

        if !value.nil?
          if value.is_a?(::Sequel::Postgres::PGArray)
            res = value.to_a
          elsif value.is_a?(String)
            res = pgarray_string_to_array(value)
          end
        end

        return res
      end

      def self.pgarray_string_to_array(string)
        return string.gsub(/[{}]/, '').split(',')
      end
    end
  end
end
