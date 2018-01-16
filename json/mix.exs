defmodule Json.Mixfile do
  use Mix.Project

  def project do
    [
      app: :json,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      escript: [ main_module: Json ],
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [{:poison, "~> 3.1"},]
  end
end
