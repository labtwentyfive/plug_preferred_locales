defmodule PlugPreferredLocales do
  @moduledoc """
  PlugPreferredLocales is a plug to parse the `"accept-language"` header and
  store a list of preferred locales in the `:private` key of the
  `%Plug.Conn{}`.

  ## Options

  The following options are supported:

  * `:ignore_area` - Determines wether to ignore the area part of a locale. This
    would cause the preferred locale `en-US` to be listed solely as `en`.
  """

  @type quality() :: {String.t(), Float.t()}

  require Logger

  @doc false
  def init(options), do: options

  @doc false
  def call(conn, options) do
    ignore_area = Keyword.get(options, :ignore_area, false)

    preferred_locales =
      conn
      |> Plug.Conn.get_req_header("accept-language")
      |> parse_accept_header()
      |> maybe_ignore_area(ignore_area)

    Plug.Conn.put_private(conn, :plug_preferred_locales, preferred_locales)
  end

  @doc """
  Parses the accept header (if exists).

  It returns a list of language tags ordered by the quality factor.
  """
  @spec parse_accept_header([String.t()]) :: [String.t()]
  def parse_accept_header([]), do: []

  def parse_accept_header([header | _]) do
    header
    |> String.split(",")
    |> Enum.map(&parse_language_range/1)
    |> Enum.reject(&is_nil/1)
    |> Enum.sort_by(fn {_tag, quality} -> quality end, &>=/2)
    |> Enum.map(fn {tag, _quality} -> tag end)
  end

  @doc """
  Parses a language range.

  Returns a tuple with the language tag as the first element and the quality
  as the second. If no quality is specified it uses `1.0`.
  """
  @spec parse_language_range(String.t()) :: quality() | nil
  def parse_language_range(language_range) do
    case String.split(language_range, ";") do
      [language_tag] ->
        {language_tag, 1.0}

      [language_tag, "q=" <> qvalue] ->
        {language_tag, String.to_float(qvalue)}

      _other ->
        nil
    end
  end

  defp maybe_ignore_area(locales, false), do: locales

  defp maybe_ignore_area(locales, true) do
    locales
    |> Enum.map(&(&1 |> String.split("-") |> List.first()))
    |> Enum.uniq()
  end
end
