defmodule PlannerWeb.ApiView do
    use PlannerWeb, :view

    def render("index.json", %{users: users}) do
      %{
        users: Enum.map(users, &user_json/1)
      }
    end

    def render("show.json", %{user: user}) do
      %{
        user: user_json(user)
      }
    end

    def render("error.json", %{error: error}) do
      %{
        error: error
      }
    end
  
    def user_json(user) do
      %{
        id: user.id,
        username: user.username,
        role: user.role,
        image: user.image
      }
    end


  end