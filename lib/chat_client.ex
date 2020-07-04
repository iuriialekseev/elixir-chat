defmodule ChatClient do
  def start(), do: GenServer.start_link(ChatClient.Server, nil, name: :client)
  def connect(server), do: GenServer.call(:client, {:connect, server})
  def members(), do: GenServer.call(:client, {:members})
  def send(text), do: GenServer.call(:client, {:send, text})
  def receive(text, sender), do: GenServer.cast(:client, {:receive, text, sender})
end
