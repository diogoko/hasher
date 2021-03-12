# Hasher

Hashing files in Elixir using streaming functions.

## Build

```
mix escript.build
```

## Usage

```
./hasher [--quiet] --algo=ALGO [--mode=MODE] [--buffer=BUFFER] FILE1 [FILE2...]
Hash each file using the algorithm and print the digest and the file name.

--quiet          Don't print hashes and file names
--algo=ALGO      Use any algorithm supported by :crypto.hash; default = sha256
--mode=MODE      Hash using "memory" mode (:crypto.hash) or "streaming" mode
                 (:crypto.hash_init and friends); default = streaming
--buffer=BUFFER  Buffer size in bytes when using "streaming" mode;
                 default = 2097152
```

## Tests

```
mix test
```
