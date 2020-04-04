Sequel.migration do
  change do
    create_table(:tasks) do
      primary_key :id
      String :content, null: false
      Boolean :status, null: false
      DateTime :created_at, null: false
      Integer :order, null: false
      String :foreign_id, null: false
    end
  end
end
