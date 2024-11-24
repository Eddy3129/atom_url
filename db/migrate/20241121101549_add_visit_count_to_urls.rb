# frozen_string_literal: true

# Adds 'visit_count' column to 'urls' table
class AddVisitCountToUrls < ActiveRecord::Migration[8.0]
  def change
    add_column :urls, :visit_count, :integer, default: 0, null: false
  end
end
