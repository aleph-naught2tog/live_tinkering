defmodule LiveTinkeringWeb.FakeKeyboardLive do
  use Phoenix.LiveView
  alias LiveTinkeringWeb.WhiteboardView

  def render(assigns) do
    WhiteboardView.render("fake_keyboard.html", assigns)
  end

  def mount(_session, socket) do
    {:ok, socket}
  end
end