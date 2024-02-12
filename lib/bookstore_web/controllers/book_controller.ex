defmodule BookstoreWeb.BookController do
  use BookstoreWeb, :controller

  alias Bookstore.Store

  def edit(conn, %{"id" => id}) do
    book = Store.get_book(id)
    authors = Store.all_authors() |> Enum.map(fn item -> [key: item.name, value: item.id] end)

    categories =
      Store.all_categories() |> Enum.map(fn item -> [key: item.name, value: item.id] end)

    render(conn, :edit,
      item: book,
      changeset: Store.Book.book_changeset(book, %{}),
      authors: authors,
      categories: categories
    )
  end

  def show(conn, %{"id" => id}) do
    book = Store.get_book(id)
    render(conn, :show, item: book)
  end

  def update(conn, %{"book" => book, "id" => id}) do
    old_book = Store.get_book(id)
    book = Store.Book.book_changeset(old_book, book)

    case Store.update_book(book) do
      {:ok, book} ->
        conn
        |> put_flash(:info, "Book updated successfully.")
        |> redirect(to: ~p"/books/#{book.isbn}")

      {:error, changeset} ->
        render(conn, :edit, changeset: changeset)
    end
  end
end
