import Config

config :elixir, :time_zone_database, 
  Tzdata.TimeZoneDatabase

config :logger, :default_formatter,
  format: "$date $time $metadata[$level] $message\n"
