class CreateVisits < ActiveRecord::Migration[8.0]
  def change
    create_table :visits do |t|
      t.references :url, null: false, foreign_key: true
      t.string :ip_address
      t.float :latitude
      t.float :longitude
      t.string :city
      t.string :state
      t.string :country
      t.string :country_code
      t.string :postal_code
      t.string :timezone

      t.timestamps
    end
  end
end
