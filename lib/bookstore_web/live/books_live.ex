defmodule BookstoreWeb.BooksLive do
  use BookstoreWeb, :live_view
  alias Bookstore.Store
  alias Bookstore.Store.Book

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket, page: 0, per_page: 3)
     |> fetch()
     |> assign_book()}
  end

  defp fetch(%{assigns: %{page: page, per_page: per}} = socket) do
    assign(socket, items: Store.all_books([], [desc: :title], [page * per, per], [:author, :category]))
  end

  def assign_book(socket) do
    socket |> assign(:book, %Book{})
  end

  def handle_event("load-more", _, %{assigns: assigns} = socket) do
    {:noreply, socket |> assign(page: assigns.page + 1) |> fetch()}
  end
end
