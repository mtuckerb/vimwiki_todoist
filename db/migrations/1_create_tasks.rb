Sequel.migration do
  change do
    create_table(:tasks) do
      primary_key :id
      String :content, null: false
      Boolean :status, null: true
      DateTime :created_at, null: false
      Integer :order, null: true
      String :foreign_id, null: true
    end
  end
end
