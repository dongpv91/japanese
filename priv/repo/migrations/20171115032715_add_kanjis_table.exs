defmodule Kanji.Repo.Migrations.AddKanjisTable do
  use Ecto.Migration

  def change do
    create table(:kanjis) do
      add :level, :integer
      add :character, :string
      add :onyomi, :string
      add :kunyomi, :string
      add :meaning, :string

      timestamps()
    end

  end
end
