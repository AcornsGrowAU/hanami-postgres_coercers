require 'spec_helper'

describe Hanami::PostgresCoercers::PgJson do
  describe '.dump' do
    it 'dumps the value using Sequel' do
      value = double('value')
      expect(Sequel).to receive(:pg_json).with(value)
      described_class.dump(value)
    end
  end

  describe '.load' do
    context 'when the value is nil' do
      it 'returns nil' do
        expect(described_class.load(nil)).to eq nil
      end
    end

    context 'when the value is not nil' do
      context 'when the value is a json hash' do
        it 'converts the value to a hash' do
          value = Sequel::Postgres::JSONHash.new('')
          expect(value).to receive(:to_h)
          described_class.load(value)
        end

        it 'returns the hash representation' do
          value = Sequel::Postgres::JSONHash.new('')
          hash_value = double('hash value')
          allow(value).to receive(:to_h).and_return(hash_value)
          expect(described_class.load(value)).to eq hash_value
        end
      end

      context 'when the value is a json array' do
        it 'converts the value to an array' do
          value = Sequel::Postgres::JSONArray.new('')
          expect(value).to receive(:to_a)
          described_class.load(value)
        end

        it 'returns the array representation' do
          value = Sequel::Postgres::JSONArray.new('')
          array_value = double('array value')
          allow(value).to receive(:to_a).and_return(array_value)
          expect(described_class.load(value)).to eq array_value
        end
      end

      context 'when the value is a json op' do
        it 'gets the operator value' do
          value = Sequel::Postgres::JSONOp.new('')
          expect(value).to receive(:value)
          described_class.load(value)
        end

        it 'returns the operator value' do
          value = Sequel::Postgres::JSONOp.new('')
          op_value = double('array value')
          allow(value).to receive(:value).and_return(op_value)
          expect(described_class.load(value)).to eq op_value
        end
      end

      context 'when the value is a string' do
        it 'parses the string as json' do
          value = '{}'
          expect(JSON).to receive(:parse).with(value)
          described_class.load(value)
        end

        it 'returns the parsed json object' do
          value = '{}'
          json_object = double('json object')
          allow(JSON).to receive(:parse).with(value).and_return(json_object)
          expect(described_class.load(value)).to eq json_object
        end
      end
    end
  end
end
