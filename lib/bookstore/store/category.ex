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

  def category_changeset(category, attrs, _opts \\ []) do
    Ecto.Changeset.cast(category, attrs, [
      :id,
      :name,
      :parent_id
    ])
    |> case do
      %{changes: _} = changeset ->
        changeset
    end
  end
end
