# frozen_string_literal: true

# Ensure every short_code is unique
class AddUniqueIndexToUrlsShortCode < ActiveRecord::Migration[8.0]
  def change
    add_index :urls, :short_code, unique: true
  end
end
