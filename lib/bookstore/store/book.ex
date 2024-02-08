defmodule Bookstore.Store.Book do
  use Ecto.Schema

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
end
