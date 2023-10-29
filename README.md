A totally unofficial client for using the Real-Time Meteorological
Observation Network data from the Great Lakes Environmental Research
Laboratory (GLERL) in Elixir.  Currently focused on the Chicago data.

  * [Chicago Observations](https://www.glerl.noaa.gov/metdata/chi/)

## Run commands

Start the app and drop into the shell:
```iex -S mix```

Run our custom mix command to download the glerl archive:
```mix glerl```

## TODO
  - umbrella app?
  - more tests
  - make sure the supervisor tree setup makes sense and make sure the tree itself makes sense
  - text interface over a socket or something
