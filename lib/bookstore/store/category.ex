defmodule Bookstore.Store.Category do
  alias Bookstore.Store.Category
  use Ecto.Schema

  schema "categories" do
    field :name, :string
    has_many :books, Bookstore.Store.Book
    belongs_to :parent, Category
    has_many :childs, Category

    timestamps(type: :utc_datetime)
  end
end
