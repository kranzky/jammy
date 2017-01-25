Sequel.migration do
  change do
    create_table :sites do
      primary_key :id
      int :year, null: false
      String :slug, null: false
      String :name, null: false
      String :country, null: false
      String :thumbnail
      DateTime :created_at
      DateTime :updated_at
      index [:year, :slug], unique: true
    end
  end
end
