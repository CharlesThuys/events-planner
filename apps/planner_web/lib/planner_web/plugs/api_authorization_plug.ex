defmodule PlannerWeb.Plugs.ApiAuthorizationPlug do

  import Plug.Conn

  alias Planner.ApiContext

  def init(options), do: options

  def call(conn, _options) do
    conn
    |> get_token()
    |> verify_token()
    |> case do
      {:ok, user_id} -> assign(conn, :current_user, user_id)
      _unauthorized -> assign(conn, :current_user, nil)
    end
  end

  def authenticate_api_user(conn, _options) do
    if Map.get(conn.assigns, :current_user) do
      conn
    else
      conn 
      |> put_resp_content_type("application/json")
      |> send_resp(401, Jason.encode!(%{message: "Unauthorized"})) 
      |> halt
    end
  end

  def verify_token(token) do
    case ApiContext.get_api_key(token) do
      nil -> nil
      key -> {:ok, key.user_id}
    end
  end

  def get_token(conn) do
    case get_req_header(conn, "api_key") do
      [token] -> token
      _ -> nil
    end
  end

end
