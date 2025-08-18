defmodule TryalProjekWeb.UserSettingsLive do
  use TryalProjekWeb, :live_view
  alias TryalProjek.Accounts

  def mount(_params, _session, socket) do
    user = socket.assigns.current_user

    form =
      to_form(%{
        "email" => user.email,
        "password" => "",
        "password_confirmation" => ""
      }, as: "user")

    {:ok, assign(socket, form: form)}
  end

  def render(assigns) do
    ~H"""
    <div class="flex items-center justify-center min-h-screen bg-gray-50">
      <div class="w-full max-w-xl bg-white rounded-2xl shadow p-8 space-y-6">

        <!-- Avatar -->
        <div class="flex flex-col items-center">
          <svg xmlns="http://www.w3.org/2000/svg" class="w-20 h-20 text-gray-800" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
          </svg>
          <h2 class="mt-4 text-2xl font-bold"> Tetapan Pengguna </h2>
          <p class="text-sm text-center text-gray-600"> Sila Masukkan Email dan Kata Laluan baru anda untuk dikemaskini </p>
        </div>

        <!-- Form -->
        <.form for={@form} id="settings_form" phx-submit="save" phx-change="validate">

        <!-- Email -->
          <div class="mt-4">
            <label class="block text-sm font-semibold"> Email </label>
            <.input field={@form[:email]} type="email" class="mt-1 w-full" required />
          </div>

          <!-- Kata Laluan -->
          <div class="mt-4">
            <label class="block text-sm font-semibold"> Kata Laluan Baru </label>
            <.input field={@form[:password]} type="password" class="mt-1 w-full" required />
          </div>

          <!-- Sahkan Kata Laluan -->
          <div class="mt-4">
            <label class="block text-sm font-semibold"> Sahkan Kata Laluan </label>
            <.input field={@form[:password_confirmation]} type="password" class="mt-1 w-full" required />
          </div>

          <!-- Button -->
          <div class="mt-6">
            <.button type="submit" class="w-full bg-blue-500 hover:bg-blue-600 text-white py-2 rounded-lg font-semibold">
              Simpan
            </.button>
          </div>
        </.form>
      </div>
    </div>
    """
  end

  def handle_event("validate", %{"user" => params}, socket) do
    {:noreply, assign(socket, form: to_form(params, as: "user"))}
  end

  def handle_event("save", %{"user" => params}, socket) do
    user = socket.assigns.current_user

    case Accounts.update_user(user, params) do
      {:ok, _updated_user} ->
        {:noreply,
         socket
         |> put_flash(:info, "Tetapan berjaya disimpan.")
         |> push_navigate(to: ~p"/userdashboard")}

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset, as: "user"))}
    end
  end
end
