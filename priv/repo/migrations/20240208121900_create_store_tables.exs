defmodule Bookstore.Repo.Migrations.CreateStoreTables do
  use Ecto.Migration

  def change do
    create table(:authors) do
      add :name, :string, null: false
      add :birth_date, :date, null: false
      timestamps()
    end

    create table(:categories) do
      add :name, :string, null: false
      add :parent_id, references(:categories, on_delete: :delete_all)
      timestamps()
    end

    create table(:books) do
      add :isbn, :string, primary_key: true
      add :title, :string, null: false
      add :summary, :string
      add :price, :float
      add :quantity, :integer
      add :editor, :string
      add :publish_date, :date
      add :image, :binary
      add :author_id, references(:authors, on_delete: :delete_all), null: false
      add :category_id, references(:categories, on_delete: :delete_all), null: false
      timestamps()
    end

    create index(:books, [:title])

    create unique_index(:categories, [:name])
  end
end
