# frozen_string_literal: true

# Allow URLs to not be assigned to any user (not login)
class ChangeUserIdToAllowNullInUrls < ActiveRecord::Migration[8.0]
  def change
    change_column_null :urls, :user_id, true
  end
end
