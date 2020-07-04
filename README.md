# Chat

## Server

```bash
iex --sname server@localhost -S mix
```

## Client

```bash
iex --sname name@localhost -S mix
```

```elixir
import ChatClient
# ChatClient

connect :server@host
# :ok

members
# [name@host, other_name@host]

send "Hello World"
# name@host: Hello World
# :ok
```
