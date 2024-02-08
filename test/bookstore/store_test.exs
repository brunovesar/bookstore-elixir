defmodule Bookstore.StoreTest do
  alias Bookstore.Store.Category
  use Bookstore.DataCase

  alias Bookstore.Store
  alias Bookstore.StoreFixtures
  alias Bookstore.Store.{Book, Author}


  describe "get_all_books/2" do
    test "returns empty if there are no books" do
      assert [] = Store.all_books()
    end

    test "returns all books if there are books" do
      with {:ok, author} = Store.insert_author(%Author{name: StoreFixtures.unique_name("Author"), birth_date: ~D[2000-01-01]}),
      {:ok, category} = Store.insert_category(%Category{name: StoreFixtures.unique_name("Category")}),
      {:ok, book} = Store.insert_book(%Book{
        isbn: StoreFixtures.unique_name("ISBN"),
        title: StoreFixtures.unique_name("Book"),
        publish_date: ~D[2020-01-01],
        price: 10.0,
        quantity: 10,
        editor: StoreFixtures.unique_name("Editor"),
        image: "path/to/file",
        author_id: author.id,
        category_id: category.id
      }) do
        assert [book] == Store.all_books()
      end
    end
    test "returns all books if there are many and a page of books if requested" do
      with {:ok, author} = Store.insert_author(%Author{name: StoreFixtures.unique_name("Author"), birth_date: ~D[2000-01-01]}),
      {:ok, category} = Store.insert_category(%Category{name: StoreFixtures.unique_name("Category")}),
      {:ok, book1} = Store.insert_book(%Book{
        isbn: StoreFixtures.unique_name("ISBN"),
        title: StoreFixtures.unique_name("Book"),
        publish_date: ~D[2020-01-01],
        price: 10.0,
        quantity: 10,
        editor: StoreFixtures.unique_name("Editor"),
        image: "path/to/file",
        author_id: author.id,
        category_id: category.id
      }),
      {:ok, book2} = Store.insert_book(%Book{
        isbn: StoreFixtures.unique_name("ISBN"),
        title: StoreFixtures.unique_name("Book"),
        publish_date: ~D[2020-01-01],
        price: 10.0,
        quantity: 10,
        editor: StoreFixtures.unique_name("Editor"),
        image: "path/to/file",
        author_id: author.id,
        category_id: category.id
      }),
      {:ok, book3} = Store.insert_book(%Book{
        isbn: StoreFixtures.unique_name("ISBN"),
        title: StoreFixtures.unique_name("Book"),
        publish_date: ~D[2020-01-01],
        price: 10.0,
        quantity: 10,
        editor: StoreFixtures.unique_name("Editor"),
        image: "path/to/file",
        author_id: author.id,
        category_id: category.id
      }) do
        assert [book1, book2, book3] == Store.all_books()
        assert [book2] == Store.all_books(%{}, {1, 1})
      end
    end
  end

end
