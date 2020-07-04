defmodule ChatServer.Server do
  use GenServer

  def init(_) do
    IO.puts("Chat server started on #{node()}")
    {:ok, {_members = MapSet.new()}}
  end

  def handle_call({:connect, member}, _from, {members}) do
    IO.puts("#{member} is connected")
    {:reply, :ok, {MapSet.put(members, member)}}
  end

  def handle_call({:broadcast, text, sender}, _from, {members}) do
    IO.puts("Broadcasting #{text} to members")
    broadcast(members, text, sender)
    {:reply, :ok, {members}}
  end

  def handle_call({:members}, _from, {members}) do
    IO.puts("Members list requested")
    {:reply, {:ok, MapSet.to_list(members)}, {members}}
  end

  defp broadcast(members, text, sender) do
    Enum.each(members, fn member ->
      :rpc.call(member, ChatClient, :receive, [text, sender])
    end)
  end
end
