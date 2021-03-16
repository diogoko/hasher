defmodule HasherMain do
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
        &Hasher.hash_streaming(&1, &2, buffer_size)
      else
        &Hasher.hash_memory/2
      end

    print_result =
      fn file, hash ->
        if not quiet do
          IO.puts("#{hash}  #{file}")
        end
      end

    args
    |> Enum.each(
      fn file ->
        hash = do_hash.(file, String.to_atom(algo))
        print_result.(file, hash)
      end
    )
  end
end
