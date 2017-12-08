defmodule JapaneseWeb.PageController do
  use JapaneseWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
