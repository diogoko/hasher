defmodule HasherTest do
  use ExUnit.Case
  doctest Hasher

  @tiny_path "/tmp/hasher-tiny"

  setup do
    File.write!(@tiny_path, "Hello, World!")

    on_exit(fn ->
      File.rm(@tiny_path)
    end)
  end

  describe "calculate correctly" do
    test "memory md5" do
      assert Hasher.hash_memory(@tiny_path, :md5) == "65a8e27d8879283831b664bd8b7f0ad4"
    end

    test "memory sha256" do
      assert Hasher.hash_memory(@tiny_path, :sha256) == "dffd6021bb2bd5b0af676290809ec3a53191dd81c7f70a4b28688a362182986f"
    end

    test "streaming md5" do
      assert Hasher.hash_streaming(@tiny_path, :md5, 5) == "65a8e27d8879283831b664bd8b7f0ad4"
    end

    test "streaming sha256" do
      assert Hasher.hash_streaming(@tiny_path, :sha256, 5) == "dffd6021bb2bd5b0af676290809ec3a53191dd81c7f70a4b28688a362182986f"
    end
  end

  describe "calculate in parallel" do
    test "memory" do
      assert Hasher.hash_memory(@tiny_path, [:md5, :sha256]) ==
        ["65a8e27d8879283831b664bd8b7f0ad4", "dffd6021bb2bd5b0af676290809ec3a53191dd81c7f70a4b28688a362182986f"]
    end

    test "streaming" do
      assert Hasher.hash_streaming(@tiny_path, [:md5, :sha256], 5) ==
        ["65a8e27d8879283831b664bd8b7f0ad4", "dffd6021bb2bd5b0af676290809ec3a53191dd81c7f70a4b28688a362182986f"]
    end
  end
end
