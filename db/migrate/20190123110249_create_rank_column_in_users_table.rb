class CreateRankColumnInUsersTable < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :highscore, :integer
  end
end
