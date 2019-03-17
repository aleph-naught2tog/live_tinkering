defmodule LiveTinkeringWeb.WhiteboardLive do
  use Phoenix.LiveView
  alias LiveTinkeringWeb.WhiteboardView

  def render(assigns) do
    WhiteboardView.render("index.html", assigns)
  end


  def mount(_session, socket) do
    {:ok, assign(socket, message: "")}
  end

  def handle_info({:keyup, value}, socket) do
    IO.inspect(value, label: "up")
    {:noreply, socket}
  end

  def handle_info({:keydown, value}, socket) do
    IO.inspect(value, label: "down")
    value
    |> map_key()
    |> update_message(socket)
    |> noreply()
  end

  def handle_info({:keypress, value}, socket) do
    IO.inspect(value, label: "press")
    {:noreply, socket}
  end

  def handle_info({:child_ok, _child_pid}, socket) do
    {:noreply, socket}
  end

  defp map_key("Space"), do: " "
  defp map_key(<<"Meta", _rest::binary>>), do: ""
  defp map_key(<<"Shift", _rest::binary>>), do: ""
  defp map_key(<<"Control", _rest::binary>>), do: ""
  defp map_key(<<"Alt", _rest::binary>>), do: ""
  defp map_key(key), do: key

  defp update_message(key, %{assigns: assigns} = socket) do
    socket
    |> assign(:message, assigns[:message] <> key)
  end

  defp noreply(socket), do: {:noreply, socket}
end