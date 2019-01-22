class ChangePasswordType < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :password, :string
    end
  end

