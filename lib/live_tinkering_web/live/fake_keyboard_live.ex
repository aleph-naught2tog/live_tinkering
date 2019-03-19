defmodule LiveTinkeringWeb.FakeKeyboardLive do
  use Phoenix.LiveView
  alias LiveTinkeringWeb.BearGameView

  def render(assigns) do
    BearGameView.render("fake_keyboard.html", assigns)
  end

  def mount(_session, socket) do
    send(socket.parent_pid, {:child_ok, self()})
    {:ok, socket}
  end

  def handle_event("keyboard_proxy", <<"keyup", "::", value::binary>>, socket) do
    handle_keyboard_event("keyup", value, socket)
  end

  def handle_event("keyboard_proxy", <<"keydown", "::", value::binary>>, socket) do
    handle_keyboard_event("keydown", value, socket)
  end

  def handle_event("reset", _, socket) do
    send(socket.parent_pid, :reset)
    {:noreply, socket}
  end

  defp handle_keyboard_event(kind, value, socket) do
    send(socket.parent_pid, {String.to_atom(kind), value})
    {:noreply, socket}
  end
end
