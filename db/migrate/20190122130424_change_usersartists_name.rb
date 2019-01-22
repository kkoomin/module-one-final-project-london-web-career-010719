class ChangeUsersartistsName < ActiveRecord::Migration[5.0]
  def change
    rename_table :users_artists, :user_artists
  end
end
