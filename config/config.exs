import Config

config :elixir, :time_zone_database, Tz.TimeZoneDatabase

# TODO figure this out, format no longer seems to work after 1.17 upgrade.
# config :logger, :default_formatter,
#   format: "$date $time $metadata[$level] $message fuck"
