require 'spec_helper'

describe Hanami::PostgresCoercers::PgArray do
  let(:described_class) { Class.new(Hanami::PostgresCoercers::PgArray) }

  describe '.type' do
    it 'sets the type instance variable' do
      described_class.type 'foobar'
      expect(described_class.instance_variable_get(:@type)).to eq 'foobar'
    end
  end

  describe '.dump' do
    it 'dumps the typed value using Sequel' do
      described_class.instance_variable_set(:@type, :plugin)
      value = double('value')
      expect(Sequel).to receive(:pg_array).with(value, :plugin)
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
      context 'when the value is a pg array' do
        it 'converts the value to an array' do
          value = Sequel::Postgres::PGArray.new([])
          expect(value).to receive(:to_a)
          described_class.load(value)
        end

        it 'returns the array representation' do
          value = Sequel::Postgres::PGArray.new([])
          array_value = double('array value')
          allow(value).to receive(:to_a).and_return(array_value)
          expect(described_class.load(value)).to eq array_value
        end
      end

      context 'when the value is a string' do
        it 'converts the string to an array' do
          array_string = '{foo,bar}'
          expect(described_class).to receive(:pgarray_string_to_array)
            .with(array_string)
          described_class.load(array_string)
        end

        it 'returns the array representation' do
          array_string = '{foo,bar}'
          array_value = double('array')
          allow(described_class).to receive(:pgarray_string_to_array)
            .with(array_string).and_return(array_value)
          expect(described_class.load(array_string)).to eq array_value
        end
      end
    end
  end

  describe '.pgarray_string_to_array' do
    it 'converts the array string to an array' do
      expect(described_class.pgarray_string_to_array('{foo,bar}'))
        .to eq(['foo', 'bar'])
    end

    it 'removes the curly braces from the string' do
      array_string = '{foo,bar}'
      expect(array_string).to receive(:gsub).with(/[{}]/, '')
        .and_return('foo,bar')
      described_class.pgarray_string_to_array(array_string)
    end

    it 'splits on comma' do
      array_string = '{foo,bar}'
      braceless_array_string = 'foo,bar'
      allow(array_string).to receive(:gsub).with(/[{}]/, '')
        .and_return(braceless_array_string)
      expect(braceless_array_string).to receive(:split).with(',')
      described_class.pgarray_string_to_array(array_string)
    end

    it 'returns the array' do
      array_string = '{foo,bar}'
      braceless_array_string = 'foo,bar'
      allow(array_string).to receive(:gsub).with(/[{}]/, '')
        .and_return(braceless_array_string)
      result = double('resulting array')
      allow(braceless_array_string).to receive(:split).with(',')
        .and_return(result)
      expect(described_class.pgarray_string_to_array(array_string)).to eq result
    end
  end
end
