defmodule LiveTinkeringWeb.FakeKeyboardLive do
  use Phoenix.LiveView
  alias LiveTinkeringWeb.WhiteboardView

  def render(assigns) do
    WhiteboardView.render("fake_keyboard.html", assigns)
  end

  def mount(_session, socket) do
    {:ok, socket}
  end

  def handle_event("keyup", value, socket) do
    IO.inspect(value, label: "keyup")
    {:noreply, socket}
  end

  def handle_event("keypress", value, socket) do
    IO.inspect(value, label: "keypress")
    {:noreply, socket}
  end

  def handle_event("keydown", value, socket) do
    IO.inspect(value, label: "keydown")
    {:noreply, socket}
  end
end