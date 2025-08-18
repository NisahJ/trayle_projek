defmodule TryalProjekWeb.UserSettingsLive do
  use TryalProjekWeb, :live_view
  alias TryalProjek.Accounts


  ## UI
  def render(assigns) do
    ~H"""
    <div class="flex items-center justify-center min-h-screen bg-gray-50">
      <div class="w-full max-w-xl bg-white rounded-2xl shadow p-8 space-y-6">

        <!-- Avatar -->
        <div class="flex flex-col items-center">
          <svg xmlns="http://www.w3.org/2000/svg" class="w-20 h-20 text-gray-800" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
          </svg>
          <h2 class="mt-4 text-2xl font-bold">Tetapan Pengguna</h2>
          <p class="text-sm text-center text-gray-600">
            Sila masukkan email atau kata laluan baru anda untuk dikemaskini.
          </p>
        </div>

        <!-- Form Update Email -->
        <.simple_form for={@email_form} id="email_form" phx-submit="update_email">
          <.input field={@email_form[:email]} type="email" label="New email" required />
          <.input field={@email_form[:current_password]} type="password" label="Current password" required />

          <:actions>
             <button type="submit"
                 class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
                   Simpan email
              </button>
          </:actions>
        </.simple_form>

        <hr class="my-6" />

        <!-- Form Update Password -->
        <.simple_form for={@password_form} id="password_form" phx-submit="update_password">
          <.input field={@password_form[:current_password]} type="password" label="Current password" required />
          <.input field={@password_form[:password]} type="password" label="New password" required />
          <.input field={@password_form[:password_confirmation]} type="password" label="Confirm new password" required />

          <:actions>
          <button type="submit"
          class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
              Simpan Kata Laluan
            </button>
          </:actions>
        </.simple_form>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    user = socket.assigns.current_user

    {:ok,
     socket
     |> assign(:email_form, to_form(%{"email" => user.email}, as: "user"))
     |> assign(:password_form, to_form(%{}, as: "user"))}
  end

  ## Handle update email
  @spec handle_event(<<_::32, _::_*32>>, map(), any()) :: {:noreply, any()}
  def handle_event("update_email", %{"user" => user_params}, socket) do
    current_password = user_params["current_password"]

    case Accounts.apply_user_email(socket.assigns.current_user, current_password, user_params) do
      {:ok, _applied_user} ->
        {:noreply,
         socket
         |> put_flash(:info, "Check your inbox for a confirmation link.")
         |> assign(:email_form, to_form(%{"email" => socket.assigns.current_user.email}, as: "user"))}

      {:error, changeset} ->
        {:noreply, assign(socket, :email_form, to_form(changeset, as: "user"))}
    end
  end

  ## Handle update password
  def handle_event("update_password", %{"user" => user_params}, socket) do
    current_password = user_params["current_password"]

    case Accounts.update_user_password(socket.assigns.current_user, current_password, user_params) do
      {:ok, user} ->
        {:noreply,
         socket
         |> put_flash(:info, "Password updated successfully.")
         |> assign(:current_user, user)
         |> assign(:password_form, to_form(%{}, as: "user"))}

      {:error, changeset} ->
        {:noreply, assign(socket, :password_form, to_form(changeset, as: "user"))}
    end
  end
end
