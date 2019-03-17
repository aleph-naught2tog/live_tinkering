defmodule LiveTinkeringWeb.WhiteboardController do
  use LiveTinkeringWeb, :controller
  alias Phoenix.LiveView
  alias LiveTinkeringWeb.WhiteboardLive

  def index(conn, params) do
    LiveView.Controller.live_render(conn, WhiteboardLive, session: %{})
  end
end