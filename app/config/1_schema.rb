Sequel.migration do
  change do
    create_table(:schema_info) do
      column :version, "integer", :default=>0, :null=>false
    end
    
    create_table(:sites) do
      primary_key :id
      column :year, "integer", :null=>false
      column :slug, "text", :null=>false
      column :name, "text", :null=>false
      column :country, "text", :null=>false
      column :thumbnail, "text"
      column :created_at, "timestamp without time zone"
      column :updated_at, "timestamp without time zone"
      
      index [:year, :slug], :unique=>true
    end
  end
end
