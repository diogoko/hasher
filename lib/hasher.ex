defmodule Hasher do
  def hash_memory(file, algo) when is_atom(algo) do
    {_, hashes} = hash_memory(file, [algo])

    {file, Enum.at(hashes, 0)}
  end

  def hash_memory(file, algos) when is_list(algos) do
    data = File.read!(file)

    hash_one =
      fn algo ->
        :crypto.hash(algo, data)
        |> format_hash()
      end

    {file, Enum.map(algos, hash_one)}
  end

  def hash_streaming(file, algo, buffer_size) when is_atom(algo) do
    {_, hashes} = hash_streaming(file, [algo], buffer_size)

    {file, Enum.at(hashes, 0)}
  end

  def hash_streaming(file, algos, buffer_size) when is_list(algos) do
    hash_states = Enum.map(algos, &:crypto.hash_init(&1))

    update_hashes =
      fn data, hash_states ->
        Enum.map(hash_states, &:crypto.hash_update(&1, data))
      end

    hashes =
      File.stream!(file, [:read_ahead, :binary], buffer_size)
      |> Enum.reduce(hash_states, update_hashes)
      |> Enum.map(&:crypto.hash_final(&1))
      |> Enum.map(&format_hash(&1))

    {file, hashes}
  end

  defp format_hash(hash) do
    hash
    |> Base.encode16()
    |> String.downcase
  end
end
