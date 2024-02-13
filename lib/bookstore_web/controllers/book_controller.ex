defmodule BookstoreWeb.BookController do
  use BookstoreWeb, :controller

  alias Bookstore.Store
  alias Bookstore.Store.Book

  def create(conn, changes) do
    changes = if changes["isbn"], do: changes, else: changes["book"]
    changes = save_file_from_changes(changes)
    book = Book.book_changeset(%Book{}, changes)

    case Store.insert_book(book) do
      {:ok, book} ->
        conn
        |> put_flash(:info, "Book created successfully.")
        |> redirect(to: ~p"/books/#{book.isbn}")

      {:error, changeset} ->
        conn
        |> put_flash(:error, "ISBN is already in the system, can't create book.")
        |> new(changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    case Store.delete_book(id) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Book deleted successfully.")
        |> redirect(to: ~p"/books")

      {:error, _} ->
        conn
        |> put_flash(:error, "Book was not successfully deleted.")
        |> redirect(to: ~p"/books")
    end
  end

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

  def new(conn, changeset \\ %{}) do
    authors = Store.all_authors() |> Enum.map(fn item -> [key: item.name, value: item.id] end)

    categories =
      Store.all_categories() |> Enum.map(fn item -> [key: item.name, value: item.id] end)

    render(conn, :new,
      changeset: changeset,
      authors: authors,
      categories: categories
    )
  end

  def show(conn, %{"id" => id}) do
    book = Store.get_book(id)
    render(conn, :show, item: book)
  end

  def update(conn, %{"book" => changes, "id" => id}) do
    old_book = Store.get_book(id)
    changes = save_file_from_changes(changes)
    book = Store.Book.book_changeset(old_book, changes, validate_isbn: false)

    case Store.update_book(book) do
      {:ok, book} ->
        conn
        |> put_flash(:info, "Book updated successfully.")
        |> redirect(to: ~p"/books/#{book.isbn}")

      {:error, changeset} ->
        render(conn, :edit, changeset: changeset)
    end
  end

  defp save_file_from_changes(changes) do
    upload = changes["file"]

    if upload do
      extension = Path.extname(upload.filename)
      image_path = "#{changes["isbn"]}-cover#{extension}"
      File.mkdir_p("/media/books")
      File.cp(upload.path, "/media/books/#{image_path}")
      Map.put(changes, "file", upload.filename) |> Map.put("image", image_path)
    else
      changes
    end
  end
end
