defmodule LiveTinkeringWeb.FakeKeyboardLive do
  use Phoenix.LiveView
  alias LiveTinkeringWeb.WhiteboardView

  def render(assigns) do
    WhiteboardView.render("fake_keyboard.html", assigns)
  end

  def mount(_session, socket) do
    send(socket.parent_pid, {:child_ok, self()})
    {:ok, socket}
  end

  def handle_event("keyup", value, socket) do
    handle_keyboard_event("keyup", value, socket)
  end

  def handle_event("keypress", value, socket) do
    handle_keyboard_event("keypress", value, socket)
  end

  def handle_event("keydown", value, socket) do
    handle_keyboard_event("keydown", value, socket)
  end

  defp handle_keyboard_event(kind, value, socket) do
    send(socket.parent_pid, {String.to_atom(kind), value})
    {:noreply, socket}
  end
end