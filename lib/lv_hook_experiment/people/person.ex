defmodule LvHookExperiment.People.Person do
  use Ecto.Schema
  import Ecto.Changeset

  schema "people" do
    field :birth_date, :date
    field :happiness_level, :integer
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(person, attrs) do
    person
    |> cast(attrs, [:name, :birth_date, :happiness_level])
    |> validate_required([:name])
  end
end
