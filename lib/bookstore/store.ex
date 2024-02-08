defmodule Bookstore.Store do
  import Ecto.Query, warn: false
  alias Bookstore.Repo

  alias Bookstore.Store.{Book, Author, Category}

  def all_books(_filter \\ %{}, {limit, offset} \\ {10, 0}) do
    Repo.all(from b in Book, limit: ^limit, offset: ^offset)
  end

  def get_author(id), do: Repo.get(Author, id)

  def get_book(id), do: Repo.get(Book, id)

  def get_category(id), do: Repo.get(Category, id)

  def insert_author(author = %Author{}), do: Repo.insert(author)
  def insert_book(book = %Book{}), do: Repo.insert(book)
  def insert_category(category = %Category{}), do: Repo.insert(category)

  def update_author(author = %Author{}), do: Repo.update(author)
  def update_book(book = %Book{}), do: Repo.update(book)
  def update_category(category = %Category{}), do: Repo.update(category)

end
