defmodule PlannerWeb.PageController do
  use PlannerWeb, :controller

  alias Planner.ApiContext
  alias Planner.UserContext
  alias Planner.UserContext.User

  def index(conn, _params) do
    render(conn, "index.html", role: "everyone")
  end

  def user_index(conn, _params) do
    render(conn, "index.html", role: "users")
  end

  def admin_index(conn, _params) do
    render(conn, "admin_index.html", role: "admins")
  end

  def settings(conn, _changeset) do
    pass_changeset = UserContext.change_pass(%User{})
    image_changeset = UserContext.change_image(%User{})
    current_user = Guardian.Plug.current_resource(conn)
    render(conn, "settings.html", pass_changeset: pass_changeset, image_changeset: image_changeset, keys: ApiContext.my_keys(current_user.id))
  end
end