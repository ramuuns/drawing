defmodule Drawing.Image do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(_) do
    {:ok, %{image: nil}}
  end

  def set_image(pid, image) do
    GenServer.call(pid, {:set_image, image})
  end

  def get_image(pid) do
    GenServer.call(pid, :get_image)
  end

  @impl true
  def handle_call({:set_image, image}, _from, _state) do
    {:reply, {:ok, image}, %{image: image}}
  end

  def handle_call(:get_image, _from, %{image: image} = state) do
    {:reply, {:ok, image}, state}
  end
end
