defmodule Bookstore.Store do
  import Ecto.Query, warn: false
  alias Bookstore.Repo

  alias Bookstore.Store.{Book, Author, Category}

  def all_authors(), do: Repo.all(Author)

  def all_books(filter \\ [], order \\ [desc: :isbn], page_info \\ [0, 10], preload \\ []) do
    [offset, limit] = page_info
    query = from b in Book, where: ^filter, order_by: ^order,  limit: ^limit, offset: ^offset, preload: ^preload
    Repo.all(query)
  end


  def all_categories(), do: Repo.all(Category)

  @spec get_author(any()) :: any()
  def get_author(id), do: Repo.get(Author, id)

  def get_book(id) do
    query = from b in Book, preload: :author, preload: :category
    Repo.get(query, id)
  end

  def get_category(id), do: Repo.get(Category, id)

  def insert_author(author = %Author{}), do: Repo.insert(author)
  def insert_book(book = %Book{}), do: Repo.insert(book)
  def insert_category(category = %Category{}), do: Repo.insert(category)

  def update_author(author = %Author{}), do: Repo.update(author)
  def update_book(book), do: Repo.update(book)
  def update_category(category = %Category{}), do: Repo.update(category)
end
