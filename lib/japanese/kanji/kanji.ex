defmodule Japanese.Kanji do
  @moduledoc """
  Model cho bảng kanjis
  """

  use Ecto.Schema
  import Ecto.Changeset


  schema "kanjis" do
    field :level, :integer
    field :character, :string
    field :onyomi, :string
    field :kunyomi, :string
    field :meaning, :string
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  Validate
  """
  def changeset(kanji, params \\ %{}) do
    kanji
    |> cast(params, [:level, :character, :onyomi, :kunyomi, :meaning])
    |> validate_required([:level, :character])
    |> validate_inclusion(:age, 0..5)
  end
end
