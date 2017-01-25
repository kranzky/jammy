Sequel.migration do
  change do
    create_table :sites do
      primary_key :id
      int :year null: false
      String :slug, null: false
      String :name, null: false
      int location, null: false
      String :country, null: false
      String :thumbnail
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
