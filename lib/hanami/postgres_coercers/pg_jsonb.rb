require 'hanami/model/coercer'

module Hanami
  module PostgresCoercers
    class PgJsonb < Hanami::Model::Coercer
      def self.dump(value)
        return ::Sequel.pg_jsonb(value)
      end

      def self.load(value)
        res = nil

        if !value.nil?
          if value.is_a?(::Sequel::Postgres::JSONBHash)
            res = value.to_h
          elsif value.is_a?(::Sequel::Postgres::JSONBArray)
            res = value.to_a
          elsif value.is_a?(::Sequel::Postgres::JSONBOp)
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
