defmodule PlugPreferredLocales.MixProject do
  use Mix.Project

  def project do
    [
      app: :plug_preferred_locales,
      version: "0.1.0",
      elixir: "~> 1.4",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: description(),
      docs: [
        main: "PlugPreferredLocales",
        extras: ["README.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  def package do
    [
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/labtwentyfive/plug_preferred_languages",
        "lab25" => "https://www.lab25.de"
      }
    ]
  end

  def description do
    """
    Parses the `accept-language` header and sets the key
    `:plug_preferred_locales` of `%Plug.Conn{}` to a list of preferred locales.
    """
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug, "~> 1.5", optional: true},
      {:ex_doc, "~> 0.18", only: :dev}
    ]
  end
end
