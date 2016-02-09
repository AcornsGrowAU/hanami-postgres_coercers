[![Build Status](https://travis-ci.com/Acornsgrow/hanami-postgres_coercers.svg?token=j8fT5VPY65oQ5xziayzW&branch=master)](https://travis-ci.com/Acornsgrow/hanami-postgres_coercers)

# Hanami::PostgresCoercers

Hanami::PostgresCoercers provides a collection of Hanami coercers for postgres
extensions.  The following types are currently supported:

* Hanami::PostgresCoercers::PgArray (PGArray, ArrayOp)
* Hanami::PostgresCoercers::PgJson (JSONHash, JSONArray, JSONOp)
* Hanami::PostgresCoercers::PgJsonb (JSONBHash, JSONBArray, JSONBOp)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hanami-postgres_coercers'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hanami-postgres_coercers

## Usage

Assuming a migration like:

```ruby
Hanami::Model.migration do
  change do
    extension :pg_enum
    extension :pg_array
    create_enum :role, %w(user admin)
    create_table :users do
      primary_key :id, null: false,
                       type: "uuid",
                       default: Sequel.function(:uuid_generate_v4)
      column :roles,   "role[]"
      column :profile, "jsonb"
    end
  end
end
```

Reference the appropriate coercer in the Hanami model mapping.

```ruby
require "hanami/postgres_coercers"

# Hanami::PostgresCoercers::PgArray is intended to be used with enums;
# you must subclass the coercer and specify the type
class RoleArray < Hanami::PostgresCoercers::PgArray
  type :role
end

Hanami::Model.configure do
  mapping do
    collection :users do
      entity     User
      repository UserRepository
    
      attribute :id,      String
      attribute :roles,   RoleArray
      attribute :profile, Hanami::PostgresCoercers::PgJsonb
    end
  end
end.load!
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Acornsgrow/hanami-postgres_coercers.

