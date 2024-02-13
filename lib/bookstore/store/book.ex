defmodule Bookstore.Store.Book do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:isbn, :string, []}
  schema "books" do
    field :title, :string
    field :publish_date, :date
    field :price, :float
    field :quantity, :integer
    field :editor, :string
    field :image, :string

    belongs_to :category, Bookstore.Store.Category
    belongs_to :author, Bookstore.Store.Author

    timestamps(type: :utc_datetime)
  end

  def book_changeset(book, attrs, opts \\ []) do
    Ecto.Changeset.cast(book, attrs, [
      :isbn,
      :title,
      :publish_date,
      :price,
      :quantity,
      :editor,
      :image,
      :author_id,
      :category_id
    ])
    |> case do
      %{changes: _} = changeset ->
        changeset
        |> maybe_validate_unique_isbn(opts)
    end
  end

  defp maybe_validate_unique_isbn(changeset, opts) do
    if Keyword.get(opts, :validate_isbn, true) do
      changeset
      |> unsafe_validate_unique(:isbn, Bookstore.Repo)
      |> unique_constraint(:isbn)
    else
      changeset
    end
  end
end
