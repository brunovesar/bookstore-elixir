defmodule Bookstore.Store.Book do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:isbn, :string, []}
  schema "books" do
    field :title, :string
    field :summary, :string
    field :publish_date, :date
    field :price, :float
    field :quantity, :integer
    field :editor, :string
    field :image, :string

    belongs_to :category, Bookstore.Store.Category
    belongs_to :author, Bookstore.Store.Author

    timestamps(type: :utc_datetime)
  end

  def book_changeset(book, attrs, opts \\ []) do
    Ecto.Changeset.cast(book, attrs, [
      :isbn,
      :title,
      :summary,
      :publish_date,
      :price,
      :quantity,
      :editor,
      :image,
      :author_id,
      :category_id
    ])
    |> case do
      %{changes: _} = changeset ->
        changeset
        |> validate_publish_date()
        |> validate_number(:price, greater_than: 0)
        |> validate_number(:quantity, greater_than_or_equal_to: 0)
        |> validate_isbn()
        |> maybe_format_isbn_to_13_digits(opts)
        |> maybe_validate_unique_isbn(opts)
    end
  end

  defp isbn_10_reduce({number, index}, acc) do
    acc + number * (10 - index)
  end

  defp isbn_13_reduce({number, index}, acc) do
    if rem(index, 2) == 0, do: acc + number, else: acc + number * 3
  end

  defp validate_publish_date(changeset) do
    publish_date = get_field(changeset, :publish_date)

    if Date.compare(publish_date, NaiveDateTime.utc_now()) == :gt do
      add_error(changeset, :publish_date, "can't be published after today")
    else
      changeset
    end
  end

  defp validate_isbn(changeset) do
    changeset
    |> validate_required([:isbn])
    |> validate_change(:isbn, {}, fn _, value -> validate_isbn_value(value) end)
  end

  defp validate_isbn_value(value) do
    if String.starts_with?(value, "ISBN") do
      isbn_number =
        value
        |> String.replace("ISBN", "")
        |> String.replace("-", "")
        |> String.replace(" ", "")

      valid_isbn? =
        case String.length(isbn_number) do
          13 -> valid_isbn_13?(isbn_number)
          10 -> valid_isbn_10?(isbn_number)
          9 -> valid_isbn_10?("0#{isbn_number}")
          _ -> false
        end

      if valid_isbn?,
        do: [],
        else: [
          {:isbn,
           {"is not a valid isbn, check the ISBN checksum rules to verify your number",
            [validation: :format]}}
        ]
    else
      [
        {:isbn,
         {"has invalid format, needs to start with ISBN followed by 10 or 13 numbers separated by - or spaces",
          [validation: :format]}}
      ]
    end
  end

  defp valid_isbn_10?(isbn) do
    digits =
      String.graphemes(isbn)
      |> Enum.map(fn grapheme -> Integer.parse(grapheme) |> elem(0) end)

    isbn_check = Enum.take(digits, 9)
    [checksum] = Enum.take(digits, -1)

    total =
      Enum.with_index(isbn_check)
      |> Enum.reduce(0, &isbn_10_reduce/2)

    rem(11 - rem(total, 11), 11) == checksum
  end

  defp valid_isbn_13?(isbn) do
    digits =
      String.graphemes(isbn)
      |> Enum.map(fn grapheme -> Integer.parse(grapheme) |> elem(0) end)

    isbn_check = Enum.take(digits, 12)
    [checksum] = Enum.take(digits, -1)

    total =
      Enum.with_index(isbn_check)
      |> Enum.reduce(0, &isbn_13_reduce/2)

    10 - rem(total, 10) == checksum
  end

  defp maybe_format_isbn_to_13_digits(changeset, opts) do
    format_isbn? = Keyword.get(opts, :format_isbn, true)
    isbn = get_change(changeset, :isbn)

    if format_isbn? && isbn && changeset.valid? do
      isbn_number = isbn |> String.replace("ISBN", "") |> String.replace("-", "")

      isbn_13 =
        case String.length(isbn_number) do
          13 -> isbn_number
          10 -> "978#{isbn_number}"
          9 -> "9780#{isbn_number}"
          _ -> nil
        end

      digits =
        String.graphemes(isbn_13)
        |> Enum.map(fn grapheme -> Integer.parse(grapheme) |> elem(0) end)

      isbn_check = Enum.take(digits, 12)

      total =
        Enum.with_index(isbn_check)
        |> Enum.reduce(0, &isbn_13_reduce/2)

      checksum = 10 - rem(total, 10)

      new_isbn =
        "ISBN-#{isbn_check |> Enum.take(3) |> Enum.join()}-#{isbn_check |> Enum.take(-9) |> Enum.join()}#{checksum}"

      changeset
      |> put_change(:isbn, new_isbn)
    else
      changeset
    end
  end

  defp maybe_validate_unique_isbn(changeset, opts) do
    if Keyword.get(opts, :validate_isbn, true) do
      changeset
      |> unsafe_validate_unique(:isbn, Bookstore.Repo)
      |> unique_constraint(:isbn)
    else
      changeset
    end
  end
end
