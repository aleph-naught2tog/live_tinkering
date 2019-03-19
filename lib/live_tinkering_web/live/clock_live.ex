defmodule LiveTinkeringWeb.ClockLive do
  use Phoenix.LiveView

  # Must be a number greater than or equal to 1
  #   Erlang only supports resolutions of 1ms or greater.
  @update_frequency 1

  # Called by `live_render` in our template
  def render(assigns) do
    ~L{Current time (UTC): <%= @time %>}
  end

  # Runs once, on page load
  def mount(_session, socket) do
    if connected?(socket) do
      :timer.send_interval(@update_frequency, self(), :update)
    end

    {:ok, update_time(socket)}
  end

  def handle_info(:update, socket) do
    {:noreply, update_time(socket)}
  end

  defp update_time(socket) do
    assign(socket, :time, Time.utc_now())
  end
end
