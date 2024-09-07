class CreateSearches < ActiveRecord::Migration[7.2]
  def change
    create_table :searches do |t|
      t.string :query, null: false
      t.inet :ip_address, null: false
      t.boolean :complete, default: false, null: false
      t.uuid :session_id, null: false

      t.timestamps
    end
    add_index :searches, :session_id, unique: true
  end
end
