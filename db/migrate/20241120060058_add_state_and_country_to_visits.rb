class AddStateAndCountryToVisits < ActiveRecord::Migration[8.0]
  def change
    add_column :visits, :state, :string
    add_column :visits, :country, :string
  end
end
