defmodule Alchemetrics.Predefined.Beam do
  @moduledoc false

  alias Alchemetrics.Exometer
  alias Alchemetrics.Exometer.Datapoints

  @erlang_memory_metric %Alchemetrics.Exometer.Metric{
    name: [:beam, :memory],
    scope: {:function, :erlang, :memory, [], :proplist, Datapoints.memory},
    datapoints: Datapoints.memory,
    metadata: [type: :memory],
    value: nil
  }

  @erlang_statistics_metric %Alchemetrics.Exometer.Metric{
    name: [:beam, :statistics],
    scope: {:function, :erlang, :statistics, [:'$dp'], :value, Datapoints.system},
    datapoints: Datapoints.system,
    metadata: [type: :system],
    value: nil
  }

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    case Application.get_env(:alchemetrics, :instrument_beam) do
      true ->
        Exometer.ensure_created_and_subscribed @erlang_memory_metric
        Exometer.ensure_created_and_subscribed @erlang_statistics_metric
        {:ok, :added}
      _ ->
        {:ok, :added}
    end
  end
end
