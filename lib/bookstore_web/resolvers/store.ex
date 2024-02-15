defmodule BookstoreWeb.StoreResolver do
  alias Bookstore.Store

  def all_books(_root, args, _info) do
    filter =
      Enum.map([:category_id, :search], fn
        name when is_map_key(args, name) -> {name, args[name]}
        _ -> nil
      end)
      |> Enum.reject(&is_nil/1)

    order = if is_map_key(args, :order), do: Store.order_from_string(args.order), else: nil
    offset = if is_map_key(args, :offset), do: args.offset, else: 0
    limit = if is_map_key(args, :limit), do: args.limit, else: 10
    {:ok, Store.all_books(filter, order, [offset, limit])}
  end

  def all_authors(_root, _args, _info) do
    {:ok, Store.all_authors()}
  end

  def all_categories(_root, _args, _info) do
    {:ok, Store.all_categories()}
  end

  def create_author(_root, args, _info) do
    changeset = Store.Author.author_changeset(%Store.Author{}, args)

    case Store.insert_author(changeset) do
      {:ok, author} ->
        {:ok, author}

      _error ->
        {:error, "could not create author"}
    end
  end

  def create_category(_root, args, _info) do
    changeset = Store.Category.category_changeset(%Store.Category{}, args)

    case Store.insert_category(changeset) do
      {:ok, category} ->
        {:ok, category}

      _error ->
        {:error, "could not create category"}
    end
  end

  def update_author(_root, args, _info) do
    item = Store.get_author(args.id)
    changeset = Store.Author.author_changeset(item, args)

    case Store.update_author(changeset) do
      {:ok, author} ->
        {:ok, author}

      _error ->
        {:error, "could not update author"}
    end
  end

  def update_category(_root, args, _info) do
    item = Store.get_category(args.id)
    changeset = Store.Category.category_changeset(item, args)

    case Store.update_category(changeset) do
      {:ok, category} ->
        {:ok, category}

      _error ->
        {:error, "could not update category"}
    end
  end

  def delete_author(_root, args, _info) do
    {id, _} = Integer.parse(args.id)

    case Store.delete_author(id) do
      {:ok, _} ->
        {:ok, true}

      _error ->
        {:error, "could not delete author"}
    end
  end

  def delete_category(_root, args, _info) do
    {id, _} = Integer.parse(args.id)

    case Store.delete_category(id) do
      {:ok, _} ->
        {:ok, true}

      _error ->
        {:error, "could not delete category"}
    end
  end
end
