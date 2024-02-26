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

griffin =
  Bookstore.Repo.insert!(%Bookstore.Store.Author{
    name: "G. Edward Griffin",
    birth_date: ~D[1957-02-27]
  })

quigley =
  Bookstore.Repo.insert!(%Bookstore.Store.Author{
    name: "Carrol Quigley",
    birth_date: ~D[1937-02-27]
  })

sutton = Bookstore.Repo.insert!(%Bookstore.Store.Author{
  name: "Anthony Sutton",
  birth_date: ~D[1925-02-14]
})

tolkien =
  Bookstore.Repo.insert!(%Bookstore.Store.Author{
    name: "J. R. R. Tolkien",
    birth_date: ~D[1892-01-03]
  })

verne =
  Bookstore.Repo.insert!(%Bookstore.Store.Author{
    name: "Jules Verne",
    birth_date: ~D[1828-02-08]
  })

dumas =
  Bookstore.Repo.insert!(%Bookstore.Store.Author{
    name: "Alexander Dumas",
    birth_date: ~D[1802-07-24]
  })

all = Bookstore.Repo.insert!(%Bookstore.Store.Category{name: "All"})

fiction =
  Bookstore.Repo.insert!(%Bookstore.Store.Category{name: "Fiction", parent_id: all.id})

historical =
  Bookstore.Repo.insert!(%Bookstore.Store.Category{name: "Historical", parent_id: all.id})

fantastic =
  Bookstore.Repo.insert!(%Bookstore.Store.Category{name: "Fantastic", parent_id: fiction.id})

trips =
  Bookstore.Repo.insert!(%Bookstore.Store.Category{name: "Trips", parent_id: fiction.id})

books_to_insert = [
  %Bookstore.Store.Book{
    isbn: "ISBN-978-1505377439",
    title: "Prince of thieves",
    publish_date: ~D[1830-08-28],
    price: 25.0,
    quantity: 10,
    editor: "Planeta",
    image: "prince_of_thieves.jpg",
    author_id: dumas.id,
    category_id: fiction.id
  },
  %Bookstore.Store.Book{
    isbn: "ISBN-978-0140449266",
    title: "The count of Montecristo",
    publish_date: ~D[1832-08-28],
    price: 25.0,
    quantity: 10,
    editor: "Planeta",
    image: "count_montecristo.jpg",
    author_id: dumas.id,
    category_id: fiction.id
  },
  %Bookstore.Store.Book{
    isbn: "ISBN-978-0544003415",
    title: "The fellowship of the ring",
    publish_date: ~D[1954-04-12],
    price: 25.0,
    quantity: 10,
    editor: "Altaya",
    image: "the_lord_of_the_rings_1.jpg",
    author_id: tolkien.id,
    category_id: fantastic.id
  },
  %Bookstore.Store.Book{
    isbn: "ISBN-978-0008567132",
    title: "The two towers",
    publish_date: ~D[1954-08-12],
    price: 25.0,
    quantity: 10,
    editor: "Altaya",
    image: "the_lord_of_the_rings_2.jpg",
    author_id: tolkien.id,
    category_id: fantastic.id
  },
  %Bookstore.Store.Book{
    isbn: "ISBN-978-0261103597",
    title: "The return of the king",
    publish_date: ~D[1955-02-12],
    price: 25.0,
    quantity: 10,
    editor: "Altaya",
    image: "the_lord_of_the_rings_3.jpg",
    author_id: tolkien.id,
    category_id: fantastic.id
  },
  %Bookstore.Store.Book{
    isbn: "ISBN-978-1416561460",
    title: "Journey to the center of the earth",
    publish_date: ~D[1849-04-12],
    price: 25.0,
    quantity: 10,
    editor: "Altaya",
    image: "journey_center_earth.jpg",
    author_id: verne.id,
    category_id: trips.id
  },
  %Bookstore.Store.Book{
    isbn: "ISBN-978-0198818649",
    title: "20000 Leagues under the sea",
    publish_date: ~D[1851-04-12],
    price: 25.0,
    quantity: 10,
    editor: "Altaya",
    image: "20000_leagues_under_the_sea.jpg",
    author_id: verne.id,
    category_id: trips.id
  },
  %Bookstore.Store.Book{
    isbn: "ISBN-978-0230026742",
    title: "Around the world in eighty days",
    publish_date: ~D[1852-08-28],
    price: 25.0,
    quantity: 10,
    editor: "Planeta",
    image: "around_the_world_in_eighty_days.jpg",
    author_id: verne.id,
    category_id: trips.id
  },
  %Bookstore.Store.Book{
    isbn: "ISBN-978-0912986456",
    title: "The creature from jekyll island",
    publish_date: ~D[1977-04-28],
    price: 25.0,
    quantity: 10,
    editor: "Planeta",
    image: "creature_from_jekyll_island.jpg",
    author_id: griffin.id,
    category_id: historical.id
  },
  %Bookstore.Store.Book{
    isbn: "ISBN-978-0026001304",
    title: "Tragedy and hope",
    publish_date: ~D[1979-04-28],
    price: 25.0,
    quantity: 10,
    editor: "Planeta",
    image: "tragedy_and_hope.jpg",
    author_id: quigley.id,
    category_id: historical.id
  },
  %Bookstore.Store.Book{
    isbn: "ISBN-978-1939438126",
    title: "The war on gold",
    publish_date: ~D[1977-04-28],
    price: 25.0,
    quantity: 10,
    editor: "Planeta",
    image: "war_on_gold.jpg",
    author_id: sutton.id,
    category_id: historical.id
  }
]

Enum.map(books_to_insert, &Bookstore.Repo.insert!/1)
