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

connect :server@host
send "Hello World"
```
