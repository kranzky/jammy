Sequel.migration do
  change do
    add_column :games, :description, String
    add_column :games, :embed, TrueClass
  end
end
