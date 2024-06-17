defmodule DrawingWeb.IndexLive do
  use DrawingWeb, :live_view
  alias Drawing.Presence

  def render(assigns) do
    ~H"""
    <h1>Draw something...</h1>
    <canvas id="can" width="400" height="400" style="border:2px solid;" phx-hook="Canvas"></canvas>
    <div id="colors">
      <button
        class="pick-color selected"
        data-color="black"
        style="background-color:black; width:20px; height:20px; margin-left:1em;"
      >
      </button>
      <button
        class="pick-color"
        data-color="blue"
        style="background-color:blue; width:20px; height:20px; margin-left:1em;"
      >
      </button>
      <button
        class="pick-color"
        data-color="red"
        style="background-color:red; width:20px; height:20px; margin-left:1em;"
      >
      </button>
      <button
        class="pick-color"
        data-color="green"
        style="background-color:green; width:20px; height:20px; margin-left:1em;"
      >
      </button>
      <button
        class="pick-color"
        data-color="yellow"
        style="background-color:yellow; width:20px; height:20px; margin-left:1em;"
      >
      </button>
      <button
        class="pick-color"
        data-color="white"
        style="background-color:white; width:20px; height:20px; margin-left:1em;"
      >
      </button>
    </div>
    <button id="clear">Clear</button>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, image} = Drawing.Image.get_image(Drawing.TheImage)
    socket = socket |> push_event("client-image", %{image: image})
    DrawingWeb.Endpoint.subscribe("image")
    {:ok, socket}
  end

  def handle_event("image", image, socket) do
    Drawing.Image.set_image(Drawing.TheImage, image)
    DrawingWeb.Endpoint.broadcast_from(self(), "image", "update", %{})
    {:noreply, socket}
  end

  def handle_info(%{event: "update"}, socket) do
    {:ok, image} = Drawing.Image.get_image(Drawing.TheImage)
    socket = socket |> push_event("client-image", %{image: image})
    {:noreply, socket}
  end
end
