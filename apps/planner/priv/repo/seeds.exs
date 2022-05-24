# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Planner.Repo.insert!(%Planner.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

Planner.UserContext.create_user_admin(%{"password" => "t", "role" => "User", "username" => "user"})

Planner.UserContext.create_user_admin(%{"password" => "t", "role" => "Admin", "username" => "admin", "image" => "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS2VP612kHSbNzI27mAGrFGeFH73B5atcvp4A&usqp=CAU"})