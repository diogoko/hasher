defmodule Hasher do
  def hash_memory(file, algo) do
    data = File.read!(file)

    hash =
      :crypto.hash(algo, data)
      |> format_hash()

    {file, hash}
  end

  def hash_streaming(file, algo, buffer_size) do
    update_hash = fn data, hash_state -> :crypto.hash_update(hash_state, data) end

    hash =
      File.stream!(file, [:read_ahead, :binary], buffer_size)
      |> Enum.reduce(:crypto.hash_init(algo), update_hash)
      |> :crypto.hash_final()
      |> format_hash()

    {file, hash}
  end

  defp format_hash(hash) do
    hash
    |> Base.encode16()
    |> String.downcase
  end
end
