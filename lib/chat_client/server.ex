defmodule ChatClient.Server do
  use GenServer

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
    IO.puts("#{sender}: #{text}")
    {:noreply, {server}}
  end
end
