require 'hanami/model/coercer'

module Hanami
  module PostgresCoercers
    class PgJson < Hanami::Model::Coercer
      def self.dump(value)
        return ::Sequel.pg_json(value)
      end

      def self.load(value)
        res = nil

        if !value.nil?
          if value.is_a?(::Sequel::Postgres::JSONHash)
            res = value.to_h
          elsif value.is_a?(::Sequel::Postgres::JSONArray)
            res = value.to_a
          elsif value.is_a?(::Sequel::Postgres::JSONOp)
            res = value.value
          elsif value.is_a?(String)
            res = JSON.parse(value)
          end
        end

        return res
      end
    end
  end
end
