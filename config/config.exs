import Config

config :elixir, :time_zone_database, Tz.TimeZoneDatabase

config :advent, AdventOfCode.Input,
  # allow_network?: true,
  session_cookie: System.get_env("ADVENT_OF_CODE_SESSION_COOKIE")
