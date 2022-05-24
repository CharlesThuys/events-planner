defmodule PlannerWeb.PageView do
  use PlannerWeb, :view

  def new_locale(conn, locale, language_title) do
    "<a href=\"#{Routes.page_path(conn, :settings, locale: locale)}\"><img src=#{language_title} class='w-30 h-20'></a>" |> raw
  end

end
