defmodule PlugPreferredLocalesTest do
  use ExUnit.Case
  use Plug.Test
  doctest PlugPreferredLocales

  test "it works" do
    conn =
      "GET"
      |> conn("/")
      |> put_req_header("accept-language", "en-US;q=0.7,de,en;q=0.3")
      |> PlugPreferredLocales.call([])

    assert conn.private.plug_preferred_locales == ["de", "en-US", "en"]
  end

  test "it can be configured to ignore areas" do
    conn =
      "GET"
      |> conn("/")
      |> put_req_header("accept-language", "en-US,de;q=0.7,en;q=0.3")
      |> PlugPreferredLocales.call(ignore_area: true)

    assert conn.private.plug_preferred_locales == ["en", "de"]
  end

  describe "PlugPreferredLocales.parse_accept_header/1" do
    test "correctly parses a list of ranges and returns them in order" do
      assert PlugPreferredLocales.parse_accept_header(["en;q=0.5,de;q=0.6,de-DE"]) == [
               "de-DE",
               "de",
               "en"
             ]
    end
  end

  describe "PlugPreferredLocales.parse_language_range/1" do
    test "correctly parses ranges w/o qvalue" do
      assert PlugPreferredLocales.parse_language_range("en-US") == {"en-US", 1}
    end

    test "correctly parses ranges w qvalue" do
      assert PlugPreferredLocales.parse_language_range("en;q=0.5") == {"en", 0.5}
    end
  end
end
