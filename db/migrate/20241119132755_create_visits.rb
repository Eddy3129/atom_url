class CreateVisits < ActiveRecord::Migration[8.0]
  def change
    create_table :visits do |t|
      t.references :url, null: false, foreign_key: true
      t.string :ip_address
      t.string :geolocation

      t.timestamps
    end
    add_index :visits, :url_id
  end
end
