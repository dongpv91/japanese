defmodule JapaneseWeb.Schema do
  @moduledoc """
  GraphQL のスキーマ定義
  """

  use Absinthe.Schema
  use Absinthe.Relay.Schema, :modern


  alias JapaneseWeb.KanjiResolver

  alias Japanese.Kanji

  import_types JapaneseWeb.Schema.Types

  query do
    @desc "Get all posts"
    connection field :kanjis, node_type: :kanji do
      arg :level, :integer
      resolve &KanjiResolver.list/3
    end

    @desc """
    Hack to workaround https://github.com/facebook/relay/issues/112 re-exposing the root query object
    """
    field :viewer, :query do
      resolve fn
        #IO.inspect KanjiResolver.find(%{id: id}, %{})

        _, _ ->
        {:ok, %{}}
      end
    end

    @desc """
    指定されたIDを持つオブジェクトを返します。

    ※ ここに書いた説明は node query の説明に表示される。
    """
    node field do
      resolve fn
        #IO.inspect KanjiResolver.find(%{id: id}, %{})

        %{type: :kanji, id: id}, _ ->
         KanjiResolver.find(%{id: id}, %{})
      end
    end
  end

  @desc """
  IDを持つオブジェクト

  ※ ここに書いた説明は Node 型の説明に表示される。
  """
  node interface do
    resolve_type fn
      %{onyomi: _},      _ -> :kanji
      data, _ ->
        IO.inspect data
        nil
    end
  end

end
