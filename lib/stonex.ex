defmodule Stonex do
  @moduledoc """
  Stonex keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias Stonex.{Account, User}

  defdelegate create_account(params), to: Account.Create, as: :call

  defdelegate create_user(params), to: User.Create, as: :call
end
