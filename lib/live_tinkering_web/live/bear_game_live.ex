defmodule LiveTinkeringWeb.BearGameLive do
  use Phoenix.LiveView
  alias LiveTinkeringWeb.BearGameView

  import Game.Grid

  @rows 5
  @columns 10
  @initial_location {0, 0}

  def render(assigns) do
    BearGameView.render("index.html", assigns)
  end

  def mount(_session, socket) do
    {:ok, init_socket(socket)}
  end

  defp init_socket(socket) do
    socket =
      socket
      |> assign(message: "")
      |> assign(location: @initial_location)
      |> assign(last_location: @initial_location)

    grid =
      {@rows, @columns}
      |> build_grid()
      |> update_grid(socket.assigns)

    assign(socket, grid: grid)
  end

  def handle_info({:keyup, _value}, socket) do
    {:noreply, socket}
  end

  def handle_info({:keydown, value}, socket) do
    %{location: location, grid: grid} = socket.assigns

    location_map =
      value
      |> map_key()
      |> update_location(location, {@rows, @columns})

    new_grid = update_grid(grid, location_map)

    updated_socket =
      socket
      |> assign(grid: new_grid)
      |> assign(location: location_map[:location])
      |> assign(last_location: location_map[:last_location])

    {:noreply, updated_socket}
  end

  def handle_info(:reset, socket) do
    {:noreply, init_socket(socket)}
  end

  def handle_info({:child_ok, _child_pid}, socket) do
    {:noreply, socket}
  end

  defp map_key("ArrowLeft"), do: {-1, 0}
  defp map_key("ArrowRight"), do: {1, 0}
  defp map_key("ArrowDown"), do: {0, -1}
  defp map_key("ArrowUp"), do: {0, 1}
  defp map_key(_), do: {0, 0}
end
