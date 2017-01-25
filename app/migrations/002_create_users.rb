Sequel.migration do
  change do
    create_table :users do
      primary_key :id
      String :slug, null: false
      String :name, null: false
      String :image, null: false
      DateTime :created_at
      DateTime :updated_at
      index [:slug], unique: true
    end
    create_table :sites_users do
      primary_key :id
      foreign_key :site_id, :sites
      foreign_key :user_id, :users
      index [:site_id, :user_id], unique: true
    end
  end
end
