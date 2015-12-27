ExUnit.start

# Create the database, run migrations, and start the test transaction.
Mix.Task.run "ecto.create", ~w(-r Dez.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Dez.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Dez.Repo)
