defmodule LvHookExperimentWeb.PersonLive.Index do
  alias LvHookExperimentWeb.LiveStateHook
  use LvHookExperimentWeb, :live_view

  alias LvHookExperiment.People
  alias LvHookExperiment.People.Person

  on_mount LiveStateHook

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign(:people, People.list_people()) |> assign(:socket_id, socket.id)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Person")
    |> assign(:person, People.get_person!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Person")
    |> assign(:person, %Person{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing People")
    |> assign(:person, nil)
  end

  @impl true
  def handle_info({LvHookExperimentWeb.PersonLive.FormComponent, {:saved, person}}, socket) do
    {:noreply, socket |> assign(:people, People.list_people())}
  end

  @impl true
  def handle_info({:live_state, "add_person", %{"person" => person_params}}, socket) do
    case People.create_person(person_params) do
      {:ok, person} ->
        {:noreply,
         socket
         |> assign(:people, People.list_people())
         |> put_flash(:info, "Person created successfully")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    person = People.get_person!(id)
    {:ok, _} = People.delete_person(person)

    {:noreply, socket |> assign(:people, People.list_people())}
  end
end
