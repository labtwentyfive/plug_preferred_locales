# PlugPreferredLocales

[![Build Status](https://travis-ci.org/labtwentyfive/plug_preferred_locales.svg?branch=master)](https://travis-ci.org/labtwentyfive/plug_preferred_locales)

Parses the `accept-language` header and sets the key
`:plug_preferred_locales` of `%Plug.Conn{}` to a list of preferred locales.

## Documentation

Documentation is available at HexDocs:

https://hexdocs.pm/plug_preferred_locales

#### Integration with gettext

If you use the [Gettext package](https://hex.pm/packages/gettext) you can add
something like this to your router pipeline:

```Elixir
defmodule MyappWeb.Router do
  use MyappWeb, :router

  pipeline :browser do
    # ....
    plug(PlugPreferredLanguages, ignore_area: true)
    plug(:set_language)
  end

  def set_language(conn, _opts) do
    preferred_languages = MapSet.new(conn.private.plug_preferred_languages)

    available_languages =
      MyappWeb.Gettext
      |> Gettext.known_locales()
      |> MapSet.new()

    intersection = MapSet.intersection(preferred_languages, available_languages)

    if MapSet.size(intersection) > 0 do
      intersection
      |> MapSet.to_list()
      |> List.first()
      |> Gettext.put_locale()
    end

    conn
  end
end
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `plug_gettext` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:plug_preferred_locales, "~> 0.1.0"}
  ]
end
```
