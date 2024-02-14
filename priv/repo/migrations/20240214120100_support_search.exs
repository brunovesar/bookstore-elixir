defmodule Bookstore.Repo.Migrations.SupportSearch do
  use Ecto.Migration

  def up do
    execute("CREATE EXTENSION btree_gin;")

    execute """
      ALTER TABLE books
      ADD COLUMN searchable_title tsvector
      GENERATED ALWAYS AS (
        to_tsvector('english', coalesce(title, ''))
      ) STORED,
      ADD COLUMN searchable_summary tsvector
      GENERATED ALWAYS AS (
        to_tsvector('english', coalesce(summary, ''))
      ) STORED;
    """

    execute """
    ALTER TABLE authors
    ADD COLUMN searchable_name tsvector
    GENERATED ALWAYS AS (to_tsvector('english', coalesce(name, ''))) STORED;
    """

    execute """
      CREATE VIEW search_books AS
      SELECT
          b.id as book_id,(
            setweight(b.searchable_title, 'A') ||
            setweight(a.searchable_name, 'B') ||
            setweight(b.searchable_summary, 'C'))
           as searchable
      FROM
          books AS b
      JOIN authors AS a ON a.id = b.author_id;
    """

    execute """
      CREATE INDEX books_searchable_idx ON books USING gin(searchable_title, searchable_summary);
    """

    execute """
      CREATE INDEX authors_searchable_idx ON authors USING gin(searchable_name);
    """
  end

  def down do
    execute "DROP INDEX books_searchable_idx;"
    execute "DROP INDEX authors_searchable_idx;"

    execute "DROP VIEW search_books;"

    execute "ALTER TABLE books DROP COLUMN searchable_summary, DROP COLUMN searchable_title;"
    execute "ALTER TABLE authors DROP COLUMN searchable_name;"

    execute "DROP EXTENSION btree_gin"
  end
end
