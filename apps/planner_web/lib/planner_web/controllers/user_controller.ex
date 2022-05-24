defmodule PlannerWeb.UserController do
  use PlannerWeb, :controller
  alias PlannerWeb.Guardian
  alias Planner.UserContext
  alias Planner.UserContext.User
  alias Planner.EventContext
  alias Planner.ApiContext

  def index(conn, _params) do
    users = UserContext.list_users()
    render(conn, "index.html", users: users)
  end

  def user_index(conn, _params) do
    users = UserContext.list_users()
    render(conn, "user_index.html", users: users)
  end

  # Goes to register page
  def register_page(conn, _params) do
    changeset = UserContext.change_user(%User{})
    render(conn, "register.html", changeset: changeset, new_account: true)
  end

  # Registers user and redirects to his profile
  def register(conn, %{"user" => user_params}) do
    case UserContext.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> Guardian.Plug.sign_in(user)
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "register.html", changeset: changeset)
    end
  end

  # Goes to admin create account page where he can select roles
  def new(conn, _params) do
    changeset = UserContext.change_user(%User{})
    roles = UserContext.get_acceptable_roles()
    render(conn, "new.html", changeset: changeset, acceptable_roles: roles, submit_button: "Add user")
  end

  # Creates user from the admin scope
  def create(conn, %{"user" => user_params}) do
    case UserContext.create_user_admin(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        roles = UserContext.get_acceptable_roles()
        render(conn, "new.html", changeset: changeset, acceptable_roles: roles)
    end
  end

  # Show user profile
  def show(conn, %{"id" => id}) do

    current_user = Guardian.Plug.current_resource(conn)
    user = UserContext.get_user!(id)

    user_info = %{
      followerCount: UserContext.getFollowerCount(id),
      followingCount: UserContext.getFollowingCount(id),
      isFollowing: UserContext.isFollowing(current_user.id, id)
    }

    user_events = EventContext.load_events(user)   

    render(conn, "show.html", user: user, events: user_events.events, user_info: user_info)
  end

  def edit(conn, %{"id" => id}) do
    user = UserContext.get_user!(id)
    changeset = UserContext.change_user(user)
    roles = UserContext.get_acceptable_roles()
    render(conn, "edit.html", user: user, changeset: changeset, acceptable_roles: roles, submit_button: "Edit user")
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    current_user = Guardian.Plug.current_resource(conn)
    user = UserContext.get_user!(id)

    case UserContext.update_user_admin(user, current_user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, :no_permission} ->
        conn
        |> put_flash(:error, "No permission to do that.")
        |> redirect(to: Routes.event_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        roles = UserContext.get_acceptable_roles()
        render(conn, "edit.html", user: user, changeset: changeset, acceptable_roles: roles)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = UserContext.get_user!(id)
    current_user = Guardian.Plug.current_resource(conn)
    case  UserContext.delete_user(user, current_user) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User deleted successfully.")
        |> redirect(to: Routes.user_path(conn, :index))

      {:error, :no_permission} ->
        conn
        |> put_flash(:error, "No permission to do that.")
        |> redirect(to: Routes.user_path(conn, :index))
    end
  end

  def follow(conn, %{"id" => id}) do

    current_user = Guardian.Plug.current_resource(conn)
    user = UserContext.get_user!(id)

    case UserContext.createFollow(current_user, user) do
      {:ok, _follow} ->
        conn
        |> put_flash(:info, "Follow created")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, :self_follow} -> 
        conn
        |> put_flash(:error, "Can't follow yourself.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, :already_following} -> 
        conn
        |> put_flash(:error, "Already following.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, _params} ->
        conn
        |> redirect(to: Routes.user_path(conn, :show, user))
    end
  end      

  def unfollow(conn, %{"id" => id}) do

    current_user = Guardian.Plug.current_resource(conn)
    user = UserContext.get_user!(id)

    case UserContext.unfollow(current_user, user) do
      {:ok, _follow} ->
        conn
        |> put_flash(:info, "Unfollowed successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, :self_unfollow}
        conn
        |> put_flash(:error, "Can't unfollow yourself.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, :not_following} -> 
        conn
        |> put_flash(:error, "Not following.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, _params} ->
        conn
        |> redirect(to: Routes.user_path(conn, :show, user))
    end
  end      

  def change_image(conn, %{"user" => user_params}) do
    user = Guardian.Plug.current_resource(conn)
    current_user = Guardian.Plug.current_resource(conn)
    case UserContext.update_image(user, current_user, user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Image updated successfully.")
        |> redirect(to: Routes.page_path(conn, :settings))

      {:error, :no_permission} ->
        conn
        |> put_flash(:error, "No permission to do that.")
        |> redirect(to: Routes.page_path(conn, :settings))

      {:error, %Ecto.Changeset{} = image_changeset} ->
        pass_changeset = UserContext.change_pass(%User{})
        render(conn, "settings.html", pass_changeset: pass_changeset, image_changeset: image_changeset, keys: ApiContext.my_keys(current_user.id))
    end
  end

  def change_pass(conn, %{"user" => user_params}) do
    user = Guardian.Plug.current_resource(conn)
    current_user = Guardian.Plug.current_resource(conn)
    case UserContext.update_pass(user, current_user, user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Password updated successfully.")
        |> redirect(to: Routes.page_path(conn, :settings))

      {:error, :no_permission} ->
        conn
        |> put_flash(:error, "No permission to do that.")
        |> redirect(to: Routes.page_path(conn, :settings))

      {:error, %Ecto.Changeset{} = pass_changeset} ->
        image_changeset = UserContext.change_image(%User{})
        render(conn, "settings.html", pass_changeset: pass_changeset, image_changeset: image_changeset, keys: ApiContext.my_keys(current_user.id))
    end
  end
end