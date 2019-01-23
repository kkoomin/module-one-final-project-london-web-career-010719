class ChangeColumnToSetScoreDefault < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :highscore, :integer, :default => 0
  end
end
