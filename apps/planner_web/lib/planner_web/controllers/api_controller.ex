defmodule PlannerWeb.ApiController do
    use PlannerWeb, :controller
  
    alias Planner.UserContext
    alias Planner.ApiContext
    
    def index(conn, _params) do
        users = UserContext.list_users()
        render(conn, "index.json", users: users)
    end

    def show(conn, %{"id" => id}) do
      user = UserContext.get_user(id)
      if is_nil(user) do
        render(conn, "error.json", error: "User not found")
      else
        render(conn, "show.json", user: user)
      end
    end

    def generate(conn, _params) do
        current_user = Guardian.Plug.current_resource(conn)
        case ApiContext.generateKey(current_user) do
          {:ok, _struct} ->
            conn
            |> put_flash(:info, "Generated successfully.")
            |> redirect(to: Routes.page_path(conn, :settings))
          {:error, _params} ->
            conn
            |> put_flash(:error, "Something went wrong.")
            |> redirect(to: Routes.page_path(conn, :settings))
        end
    end
end
