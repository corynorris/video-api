defmodule VideoApi.Worker do
  @behaviour Honeydew.Worker

  def hello(thing) do
    Process.sleep(10_000)

    IO.puts("Hello #{thing}!")
  end
end
