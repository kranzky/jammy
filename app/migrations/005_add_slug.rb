Sequel.migration do
  change do
    add_column :games, :slug, String
  end
end
