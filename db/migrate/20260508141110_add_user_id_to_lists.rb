class AddUserIdToLists < ActiveRecord::Migration[8.1]
  def change
    add_reference :lists, :user, foreign_key: true
  end
end
