defmodule BookstoreWeb.BooksLive do
  use BookstoreWeb, :live_view
  alias Bookstore.Store
  on_mount {BookstoreWeb.UserAuth, :mount_current_user}

  def mount(_params, _session, socket) do
    {:ok,
     stream_configure(socket, :books, dom_id: &"books-#{&1.isbn}")
     |> assign(page: 0, per_page: 3, order: [:desc, :title])
     |> assign(
       categories:
         Store.all_categories() |> Enum.map(fn item -> [key: item.name, value: item.id] end),
       filter: %{"category_id" => 1}
     )
     |> fetch_categories()
     |> fetch_books()}
  end

  defp fetch_categories(%{assigns: %{filter: filter}} = socket) do
    category = filter["category_id"]
    result = Store.all_categories_descendants(category)
    assign(socket, selected_categories: result)
  end

  defp fetch_books(
         %{assigns: %{page: page, per_page: per, filter: filter, order: order}} = socket,
         reset \\ false
       ) do
    order_by =
      case order do
        "date-asc" -> [asc: :publish_date]
        "date-desc" -> [desc: :publish_date]
        "title-asc" -> [asc: :title]
        "title-desc" -> [desc: :title]
        _ -> [asc: :title]
      end

    offset = if reset, do: 0, else: page * per
    list_filter = Enum.map(filter, fn {key, value} -> {String.to_existing_atom(key), value} end)
    items = Store.all_books(list_filter, order_by, [offset, per], [:author, :category])

    stream(socket, :books, items, reset: reset)
  end

  def handle_event("load-more", _, %{assigns: assigns} = socket) do
    {:noreply, socket |> assign(page: assigns.page + 1) |> fetch_books()}
  end

  def handle_event("filter-change", params, socket) do
    {:noreply,
     socket
     |> assign(filter: %{"category_id" => params["category_id"]}, page: 0)
     |> fetch_categories()
     |> fetch_books(true)}
  end

  def handle_event("order-change", params, socket) do
    {:noreply, socket |> assign(order: params["id"], page: 0) |> fetch_books(true)}
  end
end
