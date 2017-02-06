Sequel.migration do
  change do
    create_table :games do
      primary_key :id
      int :year, null: false
      String :url, null: false
      String :name, null: false
      String :image, null: false
      String :video
      String :play
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
