# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Bookstore.Repo.insert!(%Bookstore.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

bruno =
  Bookstore.Repo.insert!(%Bookstore.Store.Author{
    name: "Bruno Vescovi",
    birth_date: ~D[1993-08-27]
  })

rodri =
  Bookstore.Repo.insert!(%Bookstore.Store.Author{
    name: "Rodrigo Vescovi",
    birth_date: ~D[1970-05-06]
  })

all = Bookstore.Repo.insert!(%Bookstore.Store.Category{name: "All"})
fiction = Bookstore.Repo.insert!(%Bookstore.Store.Category{name: "Fiction", parent_id: all.id})

historical =
  Bookstore.Repo.insert!(%Bookstore.Store.Category{name: "Historical", parent_id: all.id})

books_to_insert = [
  %Bookstore.Store.Book{
    isbn: "0000-0001",
    title: "My first book",
    publish_date: ~D[2021-08-28],
    price: 10.0,
    quantity: 10,
    editor: "Planeta",
    image: "path/to/file",
    author_id: bruno.id,
    category_id: fiction.id
  },
  %Bookstore.Store.Book{
    isbn: "0000-0002",
    title: "My second book, one historical",
    publish_date: ~D[2022-08-28],
    price: 15.0,
    quantity: 10,
    editor: "Planeta",
    image: "path/to/file",
    author_id: bruno.id,
    category_id: historical.id
  },
  %Bookstore.Store.Book{
    isbn: "0000-0003",
    title: "Infancias perdidas",
    publish_date: ~D[2001-08-28],
    price: 25.0,
    quantity: 10,
    editor: "Altaya",
    image: "path/to/file",
    author_id: rodri.id,
    category_id: historical.id
  }
]

Enum.map(books_to_insert, &Bookstore.Repo.insert!/1)
