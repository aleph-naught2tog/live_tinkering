defmodule LiveTinkeringWeb.WhiteboardLive do
  use Phoenix.LiveView
  alias LiveTinkeringWeb.WhiteboardView

  def render(assigns) do
    WhiteboardView.render("index.html", assigns)
  end


  def mount(session, socket) do
    {:ok, assign(socket, count: 0)}
  end

  def handle_info(:hello_from_the_socket, socket) do
    {:noreply, socket}
  end

  def handle_event("increment", _value, socket) do
    {:noreply, assign(socket, :count, socket.assigns[:count] + 1)}
  end

   def handle_event("decrement", _value, socket) do
    {:noreply, assign(socket, :count, socket.assigns[:count] - 1)}
  end
end