defmodule LvHookExperimentWeb.PersonLiveTest do
  use LvHookExperimentWeb.ConnCase

  import Phoenix.LiveViewTest
  import LvHookExperiment.PeopleFixtures

  @create_attrs %{birth_date: "2024-08-23", happiness_level: 42, name: "some name"}
  @update_attrs %{birth_date: "2024-08-24", happiness_level: 43, name: "some updated name"}
  @invalid_attrs %{birth_date: nil, happiness_level: nil, name: nil}

  defp create_person(_) do
    person = person_fixture()
    %{person: person}
  end

  describe "Index" do
    setup [:create_person]

    test "lists all people", %{conn: conn, person: person} do
      {:ok, _index_live, html} = live(conn, ~p"/people")

      assert html =~ "Listing People"
      assert html =~ person.name
    end

    test "saves new person", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/people")

      assert index_live |> element("a", "New Person") |> render_click() =~
               "New Person"

      assert_patch(index_live, ~p"/people/new")

      assert index_live
             |> form("#person-form", person: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#person-form", person: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/people")

      html = render(index_live)
      assert html =~ "Person created successfully"
      assert html =~ "some name"
    end

    test "updates person in listing", %{conn: conn, person: person} do
      {:ok, index_live, _html} = live(conn, ~p"/people")

      assert index_live |> element("#people-#{person.id} a", "Edit") |> render_click() =~
               "Edit Person"

      assert_patch(index_live, ~p"/people/#{person}/edit")

      assert index_live
             |> form("#person-form", person: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#person-form", person: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/people")

      html = render(index_live)
      assert html =~ "Person updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes person in listing", %{conn: conn, person: person} do
      {:ok, index_live, _html} = live(conn, ~p"/people")

      assert index_live |> element("#people-#{person.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#people-#{person.id}")
    end
  end

  describe "Show" do
    setup [:create_person]

    test "displays person", %{conn: conn, person: person} do
      {:ok, _show_live, html} = live(conn, ~p"/people/#{person}")

      assert html =~ "Show Person"
      assert html =~ person.name
    end

    test "updates person within modal", %{conn: conn, person: person} do
      {:ok, show_live, _html} = live(conn, ~p"/people/#{person}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Person"

      assert_patch(show_live, ~p"/people/#{person}/show/edit")

      assert show_live
             |> form("#person-form", person: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#person-form", person: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/people/#{person}")

      html = render(show_live)
      assert html =~ "Person updated successfully"
      assert html =~ "some updated name"
    end
  end
end
