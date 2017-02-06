Sequel.migration do
  change do
    add_column :games, :engine, String
  end
end
