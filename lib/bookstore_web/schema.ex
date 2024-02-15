defmodule BookstoreWeb.Schema do
  use Absinthe.Schema

  alias BookstoreWeb.StoreResolver
  import_types(Absinthe.Type.Custom)

  object :author do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :birth_date, non_null(:datetime)
  end

  object :category do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :parent_id, :id
    field :parent, :category
  end

  object :book do
    field :isbn, non_null(:id)
    field :title, non_null(:string)
    field :summary, :string
    field :author, :author
    field :category, :category
  end

  query do
    @desc "Get all books"
    field :all_books, non_null(list_of(non_null(:book))) do
      arg(:category_id, :id)
      arg(:search, :string)
      arg(:order, :string)
      arg(:offset, :integer)
      arg(:limit, :integer)
      resolve(&StoreResolver.all_books/3)
    end

    @desc "Get all authors"
    field :all_authors, non_null(list_of(non_null(:author))) do
      resolve(&StoreResolver.all_authors/3)
    end

    @desc "Get all categories"
    field :all_categories, non_null(list_of(non_null(:category))) do
      resolve(&StoreResolver.all_categories/3)
    end
  end

  mutation do
    @desc "Create a new Author"
    field :create_author, :author do
      arg(:name, non_null(:string))
      arg(:birth_date, non_null(:datetime))

      resolve(&StoreResolver.create_author/3)
    end

    @desc "Create a new Category"
    field :create_category, :category do
      arg(:name, non_null(:string))
      arg(:parent_id, :id)

      resolve(&StoreResolver.create_category/3)
    end

    @desc "Updates an Author"
    field :update_author, :author do
      arg(:id, non_null(:id))
      arg(:name, non_null(:string))
      arg(:birth_date, non_null(:datetime))

      resolve(&StoreResolver.update_author/3)
    end

    @desc "Updates a Category"
    field :update_category, :category do
      arg(:id, non_null(:id))
      arg(:name, non_null(:string))
      arg(:parent_id, :id)

      resolve(&StoreResolver.update_category/3)
    end

    @desc "Deletes an Author"
    field :delete_author, :boolean do
      arg(:id, non_null(:id))

      resolve(&StoreResolver.delete_author/3)
    end

    @desc "Deletes a Category"
    field :delete_category, :boolean do
      arg(:id, non_null(:id))

      resolve(&StoreResolver.delete_category/3)
    end
  end
end
