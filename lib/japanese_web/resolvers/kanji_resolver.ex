defmodule JapaneseWeb.KanjiResolver do


  alias Japanese.Kanji
  alias Japanese.Repo

  alias Absinthe.Relay


  import Ecto.Query

  require Logger

  def find(%{id: id}, _info) do
    case Repo.get(Kanji, id) do
      nil  -> {:error, "Kanji id #{id} not found"}
      kanji -> {:ok, kanji}
    end
  end

  def all(_parent, _args, _info) do
    {:ok, Repo.all(Kanji)}
  end



  def list(_parent, args, _info) do
    case args do
      %{first: _first, last: _last} ->
        {:error, "Passing both `first` and `last` values to paginate the `shops` connection is not supported."}
      %{first: _first, before: _before} ->
        {:error, "Passing `first` with `before` is not supported."}
      %{first: _first} ->
        do_list(args)
      %{last: _last, after: _after} ->
        {:error, "Passing `last` with `after` is not supported."}
      %{last: _last} ->
        do_list(args)
      _ ->
        {:error, "You must provide a `first` or `last` value to properly paginate the `shops` connection."}
    end
  end




  defp do_list(args) do

    count = Repo.aggregate(Kanji, :count, :id)
    query = case args do
      %{level: level} when level > 0 and level <= 5 -> Kanji |> where(level: ^level)
      _ -> Kanji
    end
    query
    |> order_by(asc: :id)
    |> Relay.Connection.from_query(&Repo.all/1, args, [count: count])
  end

  defp put_after_to_args(args) do
    case args do
      %{offset: _offset} ->
        after_cursor = Absinthe.Relay.Connection.offset_to_cursor(args.offset - 1)
        case args do
          %{after: _} -> %{args | after: after_cursor}
          _           -> Map.put(args, :after, after_cursor)
        end
      _ -> args
    end
  end
end
