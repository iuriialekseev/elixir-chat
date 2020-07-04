defmodule ChatClient.Server do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: :client)
  end

  def init(_) do
    IO.puts("Chat client started on #{node()}")
    {:ok, {_server = nil}}
  end

  def handle_call({:connect, new_server}, _from, {server}) do
    case :rpc.call(new_server, ChatServer, :connect, [_member = node()]) do
      :ok ->
        {:reply, :ok, {new_server}}

      _ ->
        {:reply, {:error, "Cannot connect to #{new_server}"}, {server}}
    end
  end

  def handle_call({:members}, _from, {server}) do
    {:ok, members} = :rpc.call(server, ChatServer, :members, [])
    {:reply, members, {server}}
  end

  def handle_call({:send, text}, _from, {server}) do
    response = :rpc.call(server, ChatServer, :broadcast, [text, _sender = node()])
    {:reply, response, {server}}
  end

  def handle_cast({:receive, text, sender}, {server}) do
    cond do
      sender == node() ->
        print_message(text, sender, :yellow)

      true ->
        print_message(text, sender, :blue)
    end

    {:noreply, {server}}
  end

  defp print_message(text, sender, color) do
    [color, "#{sender}:\n#{text}\n"]
    |> IO.ANSI.format(true)
    |> IO.puts()
  end
end
