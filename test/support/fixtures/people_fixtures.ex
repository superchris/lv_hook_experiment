defmodule LvHookExperiment.PeopleFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LvHookExperiment.People` context.
  """

  @doc """
  Generate a person.
  """
  def person_fixture(attrs \\ %{}) do
    {:ok, person} =
      attrs
      |> Enum.into(%{
        birth_date: ~D[2024-08-23],
        happiness_level: 42,
        name: "some name"
      })
      |> LvHookExperiment.People.create_person()

    person
  end
end
