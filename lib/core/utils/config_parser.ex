defmodule Core.Utils.ConfigParser do
  @moduledoc """
  Utility functions for parsing various configuration formats.
  """

  @doc """
  Parses a base64 encoded PEM certificate string into a list of DER encoded certificates.

  If the input is `nil`, an empty list is returned.
  """
  @spec parse_base64_encoded_pem_cert(String.t() | nil) :: [der_encoded_cert :: binary()]
  def parse_base64_encoded_pem_cert(base64_data) when is_binary(base64_data) do
    base64_data
    |> Base.decode64!()
    |> :public_key.pem_decode()
    |> Enum.map(&elem(&1, 1))
  end

  def parse_base64_encoded_pem_cert(nil), do: []
end
