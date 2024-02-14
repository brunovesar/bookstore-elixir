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
      with {:ok, author} <-
             Store.insert_author(%Author{
               name: StoreFixtures.unique_name("Author"),
               birth_date: ~D[2000-01-01]
             }),
           {:ok, category} <-
             Store.insert_category(%Category{name: StoreFixtures.unique_name("Category")}),
           {:ok, book} <-
             Store.insert_book(%Book{
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
      with {:ok, author} <-
             Store.insert_author(%Author{
               name: StoreFixtures.unique_name("Author"),
               birth_date: ~D[2000-01-01]
             }),
           {:ok, category} <-
             Store.insert_category(%Category{name: StoreFixtures.unique_name("Category")}),
           {:ok, book1} <-
             Store.insert_book(%Book{
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
           {:ok, book2} <-
             Store.insert_book(%Book{
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
           {:ok, book3} <-
             Store.insert_book(%Book{
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
        assert [book2] == Store.all_books([], [], [1, 1])
      end
    end

    test "returns the books filtered by the category descendants" do
      with {:ok, author} <-
             Store.insert_author(%Author{
               name: StoreFixtures.unique_name("Author"),
               birth_date: ~D[2000-01-01]
             }),
           {:ok, category1} <-
             Store.insert_category(%Category{name: StoreFixtures.unique_name("Category")}),
           {:ok, category2} <-
             Store.insert_category(%Category{
               name: StoreFixtures.unique_name("Category"),
               parent_id: category1.id
             }),
           {:ok, category3} <-
             Store.insert_category(%Category{name: StoreFixtures.unique_name("Category")}),
           {:ok, book1} <-
             Store.insert_book(%Book{
               isbn: StoreFixtures.unique_name("ISBN"),
               title: StoreFixtures.unique_name("Book"),
               publish_date: ~D[2020-01-01],
               price: 10.0,
               quantity: 10,
               editor: StoreFixtures.unique_name("Editor"),
               image: "path/to/file",
               author_id: author.id,
               category_id: category1.id
             }),
           {:ok, book2} <-
             Store.insert_book(%Book{
               isbn: StoreFixtures.unique_name("ISBN"),
               title: StoreFixtures.unique_name("Book"),
               publish_date: ~D[2020-01-01],
               price: 10.0,
               quantity: 10,
               editor: StoreFixtures.unique_name("Editor"),
               image: "path/to/file",
               author_id: author.id,
               category_id: category2.id
             }),
           {:ok, _book3} <-
             Store.insert_book(%Book{
               isbn: StoreFixtures.unique_name("ISBN"),
               title: StoreFixtures.unique_name("Book"),
               publish_date: ~D[2020-01-01],
               price: 10.0,
               quantity: 10,
               editor: StoreFixtures.unique_name("Editor"),
               image: "path/to/file",
               author_id: author.id,
               category_id: category3.id
             }) do
        assert [book1, book2] == Store.all_books(category_id: category1.id)
      end
    end

    test "returns the books filtered by search" do
      with {:ok, author} <-
             Store.insert_author(%Author{
               name: StoreFixtures.unique_name("Author Find"),
               birth_date: ~D[2000-01-01]
             }),
           {:ok, other_author} <-
             Store.insert_author(%Author{
               name: StoreFixtures.unique_name("Author"),
               birth_date: ~D[2000-01-01]
             }),
           {:ok, category} <-
             Store.insert_category(%Category{name: StoreFixtures.unique_name("Category")}),
           {:ok, book1} <-
             Store.insert_book(%Book{
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
           {:ok, book2} <-
             Store.insert_book(%Book{
               isbn: StoreFixtures.unique_name("ISBN"),
               title: StoreFixtures.unique_name("Book Find"),
               publish_date: ~D[2020-01-01],
               price: 10.0,
               quantity: 10,
               editor: StoreFixtures.unique_name("Editor"),
               image: "path/to/file",
               author_id: other_author.id,
               category_id: category.id
             }),
           {:ok, _book3} <-
             Store.insert_book(%Book{
               isbn: StoreFixtures.unique_name("ISBN"),
               title: StoreFixtures.unique_name("Book"),
               publish_date: ~D[2020-01-01],
               price: 10.0,
               quantity: 10,
               editor: StoreFixtures.unique_name("Editor"),
               image: "path/to/file",
               author_id: other_author.id,
               category_id: category.id
             }) do
        assert [book1, book2] == Store.all_books(search: "Find")
      end
    end

    test "returns the books filtered by search and category" do
      with {:ok, author} <-
             Store.insert_author(%Author{
               name: StoreFixtures.unique_name("Author Find"),
               birth_date: ~D[2000-01-01]
             }),
           {:ok, other_author} <-
             Store.insert_author(%Author{
               name: StoreFixtures.unique_name("Author"),
               birth_date: ~D[2000-01-01]
             }),
           {:ok, category1} <-
             Store.insert_category(%Category{name: StoreFixtures.unique_name("Category")}),
           {:ok, category2} <-
             Store.insert_category(%Category{
               name: StoreFixtures.unique_name("Category"),
               parent_id: category1.id
             }),
           {:ok, category3} <-
             Store.insert_category(%Category{name: StoreFixtures.unique_name("Category")}),
           {:ok, _book1} <-
             Store.insert_book(%Book{
               isbn: StoreFixtures.unique_name("ISBN"),
               title: StoreFixtures.unique_name("Book"),
               publish_date: ~D[2020-01-01],
               price: 10.0,
               quantity: 10,
               editor: StoreFixtures.unique_name("Editor"),
               image: "path/to/file",
               author_id: author.id,
               category_id: category1.id
             }),
           {:ok, book2} <-
             Store.insert_book(%Book{
               isbn: StoreFixtures.unique_name("ISBN"),
               title: StoreFixtures.unique_name("Book Find"),
               publish_date: ~D[2020-01-01],
               price: 10.0,
               quantity: 10,
               editor: StoreFixtures.unique_name("Editor"),
               image: "path/to/file",
               author_id: other_author.id,
               category_id: category2.id
             }),
           {:ok, _book3} <-
             Store.insert_book(%Book{
               isbn: StoreFixtures.unique_name("ISBN"),
               title: StoreFixtures.unique_name("Book"),
               publish_date: ~D[2020-01-01],
               price: 10.0,
               quantity: 10,
               editor: StoreFixtures.unique_name("Editor"),
               image: "path/to/file",
               author_id: other_author.id,
               category_id: category3.id
             }) do
        assert [book2] == Store.all_books(search: "Find", category_id: category2.id)
      end
    end
  end

  describe "get_categories_descendants_ids/1" do
    test "returns empty if there is no categories" do
      assert [] == Store.get_categories_descendants_ids(1)
    end

    test "returns the category id if there is a single category" do
      with {:ok, category} <-
             Store.insert_category(%Category{name: StoreFixtures.unique_name("Category")}),
           {:ok, _other_category} <-
             Store.insert_category(%Category{name: StoreFixtures.unique_name("Category")}) do
        assert [category.id] == Store.get_categories_descendants_ids(category.id)
      end
    end

    test "returns the list of childs and no other categories" do
      with {:ok, category1} <-
             Store.insert_category(%Category{name: StoreFixtures.unique_name("Category")}),
           {:ok, category2} <-
             Store.insert_category(%Category{
               name: StoreFixtures.unique_name("Category"),
               parent_id: category1.id
             }),
           {:ok, _category3} <-
             Store.insert_category(%Category{name: StoreFixtures.unique_name("Category")}) do
        assert [category1.id, category2.id] == Store.get_categories_descendants_ids(category1.id)
      end
    end

    test "returns the list of descendants and no other categories" do
      with {:ok, category1} <-
             Store.insert_category(%Category{name: StoreFixtures.unique_name("Category")}),
           {:ok, category2} <-
             Store.insert_category(%Category{
               name: StoreFixtures.unique_name("Category"),
               parent_id: category1.id
             }),
           {:ok, category3} <-
             Store.insert_category(%Category{
               name: StoreFixtures.unique_name("Category"),
               parent_id: category1.id
             }),
           {:ok, category4} <-
             Store.insert_category(%Category{
               name: StoreFixtures.unique_name("Category"),
               parent_id: category2.id
             }),
           {:ok, _category5} <-
             Store.insert_category(%Category{name: StoreFixtures.unique_name("Category")}) do
        assert [category1.id, category2.id, category3.id, category4.id] ==
                 Store.get_categories_descendants_ids(category1.id)
      end
    end

    test "returns the list of descendants and no parents" do
      with {:ok, category1} <-
             Store.insert_category(%Category{name: StoreFixtures.unique_name("Category")}),
           {:ok, category2} <-
             Store.insert_category(%Category{
               name: StoreFixtures.unique_name("Category"),
               parent_id: category1.id
             }),
           {:ok, _category3} <-
             Store.insert_category(%Category{
               name: StoreFixtures.unique_name("Category"),
               parent_id: category1.id
             }),
           {:ok, category4} <-
             Store.insert_category(%Category{
               name: StoreFixtures.unique_name("Category"),
               parent_id: category2.id
             }),
           {:ok, _category5} <-
             Store.insert_category(%Category{name: StoreFixtures.unique_name("Category")}) do
        assert [category2.id, category4.id] ==
                 Store.get_categories_descendants_ids(category2.id)
      end
    end
  end
end
