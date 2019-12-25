defmodule SampsonCookbook.Repo.Migrations.EnableCitextExtension do
  @moduledoc """
  Enable citext extension if not set and add an immutable array_to_string citext function
  """

  use Ecto.Migration

  def up do
    execute ~s"""
      CREATE EXTENSION IF NOT EXISTS citext
    """

    execute ~s"""
      CREATE OR REPLACE FUNCTION f_ciarray_to_text(citext[])
        RETURNS text LANGUAGE sql IMMUTABLE AS $$SELECT lower(array_to_string($1, ' ', ''))$$;
    """
  end
end
