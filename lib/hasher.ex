defmodule Hasher do
  @megabyte 1024 * 1024

  def main(args) do
    options = [
      strict: [
        algo: :string,
        mode: :string,
        buffer: :integer,
        quiet: :boolean,
      ]
    ]

    {opts, args, _} = OptionParser.parse(args, options)

    algo = opts[:algo] || "sha256"
    mode = opts[:mode] || "streaming"
    buffer_size = opts[:buffer] || 2 * @megabyte
    quiet = opts[:quiet] || false

    do_hash =
      if mode == "streaming" do
        &hash_streaming(&1, &2, buffer_size)
      else
        &hash_memory/2
      end

    print_result =
      fn {file, hash} ->
        if not quiet do
          IO.puts("#{hash}  #{file}")
        end
      end

    args
    |> Enum.map(&do_hash.(&1, String.to_atom(algo)))
    |> Enum.map(print_result)
  end

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
