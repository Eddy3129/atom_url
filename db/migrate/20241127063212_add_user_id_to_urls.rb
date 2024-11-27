# frozen_string_literal: true

# This migration allows URLs to map with login users
class AddUserIdToUrls < ActiveRecord::Migration[8.0]
  def change
    add_reference :urls, :user, null: false, foreign_key: true
  end
end
