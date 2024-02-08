defmodule Bookstore.StoreFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bookstore.Store` context.
  """

  def unique_name(type), do: "#{type}-#{System.unique_integer()}"
end
