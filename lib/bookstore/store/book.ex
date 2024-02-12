defmodule Bookstore.Store.Book do
  use Ecto.Schema
  alias Ecto.Changeset

  @primary_key {:isbn, :string, []}
  schema "books" do
    field :title, :string
    field :publish_date, :date
    field :price, :float
    field :quantity, :integer
    field :editor, :string
    field :image, :binary

    belongs_to :category, Bookstore.Store.Category
    belongs_to :author, Bookstore.Store.Author

    timestamps(type: :utc_datetime)
  end

  def book_changeset(book, attrs) do
    Changeset.cast(book, attrs, [
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
      %{changes: _} = changeset -> changeset
    end
  end
end
