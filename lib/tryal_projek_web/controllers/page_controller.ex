defmodule TryalProjekWeb.PageController do
  use TryalProjekWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def homepage(conn, _params) do
    render(conn, :homepage)
  end

  def mengenaikami(conn, _params) do
    render(conn, :mengenaikami)
  end

end
