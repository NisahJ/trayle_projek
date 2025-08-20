defmodule TryalProjekWeb.UserProfileLive do
  use TryalProjekWeb, :live_view

  alias TryalProjek.Accounts
  alias TryalProjek.Accounts.UserProfile

  @impl true
  def mount(_params, session, socket) do
    user = Accounts.get_user!(session["user_id"])
    profile = Accounts.get_user_profile!(user.id)
    changeset = Accounts.change_user_profile(profile)

    {:ok,
     socket
     |> assign(:user, user)
     |> assign(:profile, profile)
     |> assign(:changeset, changeset)
     |> assign(:gender_options, UserProfile.gender_options())
     |> assign(:district_options, UserProfile.district_options())
     |> assign(:education_options, UserProfile.education_options())}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-xl mx-auto p-4">
      <h2 class="text-xl font-bold mb-4">Profil Pengguna</h2>

      <p><strong>Nama Penuh:</strong> <%= @user.full_name %></p>
      <p><strong>Email:</strong> <%= @user.email %></p>

      <.form for={@changeset} phx-submit="save">
        <.input field={@changeset[:ic]}           type="text"   label="IC" />
        <.input field={@changeset[:age]}          type="number" label="Umur" />
        <.input field={@changeset[:gender]}       type="select" label="Jantina"   options={@gender_options} />
        <.input field={@changeset[:phone_number]} type="text"   label="Telefon" />
        <.input field={@changeset[:address]}      type="text"   label="Alamat" />
        <.input field={@changeset[:district]}     type="select" label="Daerah"    options={@district_options} />
        <.input field={@changeset[:education]}    type="select" label="Pendidikan" options={@education_options} />

        <div class="mt-4">
          <.button class="bg-blue-500 text-white px-4 py-2 rounded">
            Kemaskini Profil
          </.button>
        </div>
      </.form>
    </div>
    """
  end

  @impl true
  def handle_event("save", %{"user_profile" => profile_params}, socket) do
    case Accounts.update_user_profile(socket.assigns.profile, profile_params) do
      {:ok, profile} ->
        {:noreply,
         socket
         |> assign(:profile, profile)
         |> put_flash(:info, "Profil berjaya dikemaskini")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
