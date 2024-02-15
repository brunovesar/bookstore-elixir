defmodule Bookstore.Store.Author do
  use Ecto.Schema

  schema "authors" do
    field :name, :string
    field :birth_date, :date
    has_many :books, Bookstore.Store.Book

    timestamps(type: :utc_datetime)
  end

  def author_changeset(author, attrs, _opts \\ []) do
    Ecto.Changeset.cast(author, attrs, [
      :id,
      :name,
      :birth_date
    ])
    |> case do
      %{changes: _} = changeset ->
        changeset
    end
  end
end
