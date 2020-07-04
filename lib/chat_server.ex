defmodule ChatServer do
  def start_link(), do: GenServer.start_link(ChatServer.Server, nil, name: :server)
  def connect(member), do: GenServer.call(:server, {:connect, member})
  def broadcast(text, sender), do: GenServer.call(:server, {:broadcast, text, sender})
  def members(), do: GenServer.call(:server, {:members})
end
