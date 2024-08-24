defmodule LvHookExperiment.Repo.Migrations.CreatePeople do
  use Ecto.Migration

  def change do
    create table(:people) do
      add :name, :string
      add :birth_date, :date
      add :happiness_level, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
