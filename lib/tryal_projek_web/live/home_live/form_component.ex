defmodule TryalProjekWeb.HomeLive.FormComponent do
  use TryalProjekWeb, :live_component

  alias TryalProjek.Homepage

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage home records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="home-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Home</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{home: home} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Homepage.change_home(home))
     end)}
  end

  @impl true
  def handle_event("validate", %{"home" => home_params}, socket) do
    changeset = Homepage.change_home(socket.assigns.home, home_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"home" => home_params}, socket) do
    save_home(socket, socket.assigns.action, home_params)
  end

  defp save_home(socket, :edit, home_params) do
    case Homepage.update_home(socket.assigns.home, home_params) do
      {:ok, home} ->
        notify_parent({:saved, home})

        {:noreply,
         socket
         |> put_flash(:info, "Home updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_home(socket, :new, home_params) do
    case Homepage.create_home(home_params) do
      {:ok, home} ->
        notify_parent({:saved, home})

        {:noreply,
         socket
         |> put_flash(:info, "Home created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
