defmodule BookstoreWeb.Context do
  @behaviour Plug

  import Plug.Conn
  alias BookstoreWeb.UserAuth

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)

    conn
    |> Absinthe.Plug.put_options(context: context)
    |> assign(:current_user, context.current_user)
  end

  @doc """
  Return the current user context based on the authorization header
  """
  def build_context(conn) do
    with conn <- UserAuth.fetch_current_user(conn, use_auth_header: true) do
      %{current_user: conn.assigns.current_user}
    else
      _ -> %{}
    end
  end
end
