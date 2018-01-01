class AddProfiles < ActiveRecord::Migration[5.1]
  def change

    create_table :operations do |t|
      t.string :uuid, null: false, index: true, unique: true
      t.string :remote_id, null: false, index: true, unique: true
      t.column :raw_data, :text, limit: 16777215
      t.datetime :finished_at
      t.timestamps null: false
    end

    create_table :profiles do |t|
      t.string :url, null: false, index: true, unique: true
      t.column :raw_data, :text, limit: 16777215
      t.column :parsed_data, :text, limit: 16777215
      t.timestamps null: false
    end

  end
end
