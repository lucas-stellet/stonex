defmodule Stonex do
  @moduledoc """
  Stonex keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias Stonex.{Account, User, Transaction, Backoffice}

  defdelegate create_account(params), to: Account.Create, as: :call
  defdelegate get_account(params), to: Account.Get, as: :call
  defdelegate update_account(params), to: Account.Update, as: :call

  defdelegate create_user(params), to: User.Create, as: :call
  defdelegate get_user(params), to: User.Get, as: :call
  defdelegate get_user_by_document(params), to: User.GetByDocument, as: :call

  defdelegate do_transfer(params), to: Transaction.Transfer.Create, as: :call
  defdelegate do_withdraw(params), to: Transaction.Withdraw.Create, as: :call

  defdelegate get_reports(params), to: Backoffice.Reports, as: :call
end
