defmodule LvHookExperiment.Repo do
  use Ecto.Repo,
    otp_app: :lv_hook_experiment,
    adapter: Ecto.Adapters.Postgres
end
