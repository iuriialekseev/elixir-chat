defmodule ChatServer do
  def connect(member), do: GenServer.call(:server, {:connect, member})
  def broadcast(text, sender), do: GenServer.call(:server, {:broadcast, text, sender})
  def members(), do: GenServer.call(:server, {:members})
end
