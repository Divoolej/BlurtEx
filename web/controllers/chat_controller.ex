defmodule BlurtEx.ChatController do
  use BlurtEx.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
