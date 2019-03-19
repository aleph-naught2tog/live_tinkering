defmodule LiveTinkeringWeb.BearGameController do
  use LiveTinkeringWeb, :controller
  alias Phoenix.LiveView
  alias LiveTinkeringWeb.BearGameLive

  def index(conn, params) do
    LiveView.Controller.live_render(conn, BearGameLive, session: %{})
  end
end
