require 'sequel'
require 'sequel/extensions/pg_array'
require 'sequel/extensions/pg_json'
require 'sequel/extensions/pg_json_ops'

# The Sequel documentation states that the pg_array extension must be loaded
# before the pg_json extension
# https://github.com/jeremyevans/sequel/blob/4.31.0/lib/sequel/extensions/pg_json.rb#L59
Sequel.extension :pg_array, :pg_array_ops, :pg_json, :pg_json_ops
