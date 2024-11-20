class RemoveGeolocationFromVisits < ActiveRecord::Migration[8.0]
  def change
    remove_column :visits, :geolocation, :string
  end
end
