defmodule SampsonCookbook.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :text, null: false
      add :password_hash, :text
      add :password, :text
    end

    execute ~s"""
      CREATE EXTENSION IF NOT EXISTS pgcrypto;
    """, ~s"""
      SELECT 1=1;
    """

    execute ~s"""
      CREATE OR REPLACE FUNCTION user_update() returns trigger AS $$
      BEGIN
        NEW.password_hash :=
          crypt(COALESCE(NEW.password, ''), gen_salt('bf'));
        NEW.password :=
          NULL;
        return NEW;
      END
      $$ LANGUAGE plpgsql;
    """, ~s"""
      DROP FUNCTION IF EXISTS user_update();
    """

    execute ~s"""
      CREATE TRIGGER user_create_trigger BEFORE INSERT
      ON users FOR EACH ROW EXECUTE PROCEDURE user_update();
    """, ~s"""
      DROP TRIGGER IF EXISTS user_create_trigger ON users;
    """

    execute ~s"""
    CREATE TRIGGER user_update_trigger BEFORE UPDATE
    ON users FOR EACH ROW
    WHEN (OLD.password IS DISTINCT FROM NEW.password AND NEW.password <> '' AND NEW.password IS NOT NULL)
    EXECUTE PROCEDURE user_update();
    """, ~s"""
      DROP TRIGGER IF EXISTS user_update_trigger ON users;
    """

    create index(:users, [:email], unique: true)
  end
end
