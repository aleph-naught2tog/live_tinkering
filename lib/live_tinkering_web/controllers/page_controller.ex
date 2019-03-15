defmodule LiveTinkeringWeb.PageController do
  use LiveTinkeringWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
