defmodule Bookstore.Store.Author do
  use Ecto.Schema

  schema "authors" do
    field :name, :string
    field :birth_date, :date
    has_many :books, Bookstore.Store.Book

    timestamps(type: :utc_datetime)
  end
end
