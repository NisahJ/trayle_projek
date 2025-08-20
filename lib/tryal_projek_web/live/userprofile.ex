defmodule TryalProjekWeb.UserProfileLive do
  use TryalProjekWeb, :live_view

  alias TryalProjek.Accounts
  alias TryalProjek.Accounts.UserProfile

  on_mount {TryalProjekWeb.UserAuth, :ensure_authenticated}

  @education_options [
    {"SPM", "SPM"},
    {"STPM", "STPM"},
    {"Diploma", "Diploma"},
    {"Ijazah Sarjana Muda", "Ijazah Sarjana Muda"},
    {"Ijazah Sarjana", "Ijazah Sarjana"},
    {"PhD", "PhD"},
    {"Sijil Kemahiran", "Sijil Kemahiran"},
    {"Lain - lain", "Lain - lain"}
  ]

  @district_options [
    "Beaufort", "Beluran", "Keningau", "Kota Belud", "Kota Kinabalu", "Kota Marudu",
    "Kuala Penyu", "Kudat", "Kunak", "Lahad Datu", "Nabawan", "Papar", "Penampang",
    "Pitas", "Putatan", "Ranau", "Sandakan", "Semporna", "Sipitang", "Tambunan",
    "Tawau", "Tenom", "Tongod", "Tuaran"
  ]

  @impl true
  def mount(_params, _session, socket) do
    profile = %UserProfile{}
    changeset = Accounts.change_user_profile(profile)

    socket =
      socket
      |> assign(:changeset, changeset)
      |> assign(:education_options, @education_options)
      |> assign(:district_options, @district_options)

    {:ok, socket}
  end

  @impl true
  def handle_event("save", %{"user_profile" => profile_params}, socket) do
    params = Map.put(profile_params, "user_id", socket.assigns.current_user.id)

    case Accounts.create_or_update_user_profile(params) do
      {:ok, _profile} ->
        {:noreply,
         socket
         |> put_flash(:info, "Profil berjaya dikemaskini")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="p-6">
      <h1 class="text-2xl font-bold mb-2">Profil Pengguna</h1>
      <p class="text-gray-600 mb-6">Kemaskini Maklumat Peribadi Anda Untuk Permohonan Kursus</p>

      <div class="flex flex-col items-center mb-6">
        <div class="w-24 h-24 rounded-full bg-gray-200 flex items-center justify-center">
          <i class="fa fa-user text-4xl text-gray-500"></i>
        </div>
        <h2 class="mt-2 font-semibold">Ahmad Bin Abdullah</h2>
        <p class="text-gray-500">ahmad@email.com</p>
      </div>

      <.form :let={f} for={@changeset} as={:user_profile} phx-submit="save" class="space-y-6">

        <!-- Maklumat Asas -->
        <div class="border rounded-xl p-4">
          <h3 class="font-semibold mb-4">📋 Maklumat Asas</h3>
          <div class="grid grid-cols-2 gap-4">
            <.input field={f[:full_name]} type="text" label="Nama Penuh" />
            <.input field={f[:email]} type="email" label="Email" />
            <.input field={f[:ic]} type="text" label="No. Kad Pengenalan" />
            <.input field={f[:age]} type="number" label="Umur" />
            <.input field={f[:gender]} type="select" label="Jantina" options={["Lelaki", "Perempuan"]} />
          </div>
        </div>

        <!-- Maklumat Perhubungan -->
        <div class="border rounded-xl p-4">
          <h3 class="font-semibold mb-4">📞 Maklumat Perhubungan</h3>
          <.input field={f[:phone_number]} type="text" label="Telefon" />
          <.input field={f[:address]} type="textarea" label="Alamat" placeholder="Masukkan alamat lengkap" />
          <.input field={f[:district]} type="select" label="Daerah" options={@district_options} />
        </div>

        <!-- Pendidikan -->
        <div class="border rounded-xl p-4">
          <h3 class="font-semibold mb-4">🎓 Pendidikan</h3>
          <.input field={f[:education]} type="select" label="Tahap Pendidikan" options={@education_options} prompt="Sila pilih tahap pendidikan anda" />
        </div>

        <!-- Lampiran Tambahan -->
        <div class="border rounded-xl p-4">
          <h3 class="font-semibold mb-4">📎 Lampiran Tambahan</h3>
          <!-- Optional upload field; schema does not include file column yet -->
        </div>

        <!-- Button -->
        <div class="flex justify-center">
          <.button class="bg-green-500 text-white px-6 py-2 rounded-xl hover:bg-green-600 transition">
            💾 Simpan Profil
          </.button>
        </div>
      </.form>
    </div>
    """
  end
end
