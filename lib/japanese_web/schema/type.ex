
defmodule JapaneseWeb.Schema.Types do
  @moduledoc """
  GraphQL のスキーマに含まれる型の定義
  """

  alias Japanese.Repo

  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern


  alias Japanese.Kanji


  # https://hexdocs.pm/absinthe_relay/Absinthe.Relay.Connection.html の "Customizing Types" を参照
  # field を独自に定義する場合、edge マクロの呼び出しは必須
  # ここに @desc でコメントを書いても、ShopConnection 型に対する説明にはならなかった
  connection node_type: :kanji do
    @desc """
    総漢字数
    """
    field :count, :integer do
      resolve fn
        _, _ -> {:ok, Repo.aggregate(Kanji, :count, :id)}
      end
    end

    @desc """
    KanjiEdge 型に対する説明
    """
    edge do
    end
  end

  @desc """
  漢字情報
  """
  node object :kanji do
    field :id,        non_null(:id)
    field :level,     non_null(:integer)
    field :character, non_null(:string)
    field :onyomi,    non_null(:string)
    field :kunyomi,   non_null(:string)
    field :meaning,   non_null(:string)
  end
end
