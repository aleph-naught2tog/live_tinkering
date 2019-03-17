defmodule LiveTinkeringWeb.WhiteboardLive do
  use Phoenix.LiveView
  alias LiveTinkeringWeb.WhiteboardView

  def render(assigns) do
    WhiteboardView.render("index.html", assigns)
  end


  def mount(_session, socket) do
    {:ok, assign(socket, message: "")}
  end


  def handle_event("keydown", value, socket) do
    IO.inspect(value, label: "keydown value")
    {:noreply, assign(socket, message: value)}
  end

  def handle_event("release", value, socket) do
    IO.inspect(value, label: "release value")
    {:noreply, assign(socket, message: value)}
  end
end