Sequel.migration do
  change do
    add_column :games, :country, String
  end
end
