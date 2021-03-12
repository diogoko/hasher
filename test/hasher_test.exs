defmodule HasherTest do
  use ExUnit.Case
  doctest Hasher

  test "calculate correctly" do
    path = "/tmp/hasher-tiny"
    File.write!(path, "Hello, World!")

    assert Hasher.hash_memory(path, :md5) == {path, "65a8e27d8879283831b664bd8b7f0ad4"}
    assert Hasher.hash_memory(path, :sha256) == {path, "dffd6021bb2bd5b0af676290809ec3a53191dd81c7f70a4b28688a362182986f"}
    assert Hasher.hash_streaming(path, :md5, 5) == {path, "65a8e27d8879283831b664bd8b7f0ad4"}
    assert Hasher.hash_streaming(path, :sha256, 5) == {path, "dffd6021bb2bd5b0af676290809ec3a53191dd81c7f70a4b28688a362182986f"}
  end
end
