# frozen_string_literal: true

# Migration to create 'urls' table with original_url, title, and short_code columns.
class CreateUrls < ActiveRecord::Migration[8.0]
  def change
    create_table :urls do |t|
      t.string :original_url
      t.string :title
      t.string :short_code

      t.timestamps
    end
  end
end
