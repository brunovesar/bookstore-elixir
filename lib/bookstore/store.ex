defmodule Bookstore.Store do
  import Ecto.Query, warn: false
  alias Bookstore.Repo

  alias Bookstore.Store.{Book, Author, Category}

  def all_authors(), do: Repo.all(Author)

  def all_books(filter \\ [], order \\ [desc: :isbn], page_info \\ [0, 10], preload \\ []) do
    [offset, limit] = page_info
    query = Book
    category_id = filter[:category_id]

    query =
      if category_id do
        query_category_descendants(category_id, query)
        |> join(:left, [b], c in "category_tree", on: c.id == b.category_id)
        |> where([b, c], not is_nil(c.id))
        |> select([b], b)
      else
        query
      end

    search = filter[:search]

    query =
      if not is_nil(search) and String.length(search) >= 3 do
        query_search_and_order(search, query)
      else
        query
        |> order_by(^order)
      end

    query =
      query
      |> limit(^limit)
      |> offset(^offset)
      |> preload(^preload)

    Repo.all(query)
  end

  def all_categories(), do: Repo.all(Category)

  def all_categories_descendants(id) do
    query =
      query_category_descendants(id)

    Repo.all(query)
  end

  def delete_book(id) do
    Repo.delete(%Book{isbn: id})
  end

  def get_author(id), do: Repo.get(Author, id)

  def get_book(id) do
    query = from b in Book, preload: :author, preload: :category
    Repo.get(query, id)
  end

  def get_category(id), do: Repo.get(Category, id)

  def get_categories_descendants_ids(id) do
    query =
      query_category_descendants(id)
      |> select([ct], %{category_ids: fragment("ARRAY_AGG(?)", ct.id)})

    result = Repo.one(query)
    if result, do: if(result.category_ids, do: result.category_ids, else: []), else: []
  end

  def insert_author(author), do: Repo.insert(author)
  def insert_book(book), do: Repo.insert(book)
  def insert_category(category), do: Repo.insert(category)

  defp query_category_descendants(id, query \\ {"category_tree", Category}) do
    category_initial_query =
      Category
      |> where(id: ^id)

    category_tree_recursion_query =
      Category
      |> join(:inner, [c], ct in "category_tree", on: c.parent_id == ct.id)

    category_tree_query =
      category_initial_query
      |> union_all(^category_tree_recursion_query)

    query
    |> recursive_ctes(true)
    |> with_cte("category_tree", as: ^category_tree_query)
  end

  defp query_search_and_order(search, query) do
    query
    |> join(:left, [b], sb in "search_books", on: sb.book_id == b.id)
    |> where(
      fragment(
        "searchable @@ to_tsquery(websearch_to_tsquery(?)::text || ':*')",
        ^search
      )
    )
    |> order_by([
      {
        :asc,
        fragment(
          "ts_rank_cd(searchable, to_tsquery(websearch_to_tsquery(?)::text || ':*'), 4)",
          ^search
        )
      }
    ])
  end

  def update_author(author), do: Repo.update(author)
  def update_book(book), do: Repo.update(book)
  def update_category(category), do: Repo.update(category)
end
