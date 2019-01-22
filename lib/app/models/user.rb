class User < ActiveRecord::Base
  has_many :user_artists
  has_many :artists, through: :user_artists

  def password_checker(password)
    password.to_i == self.password ?  true : false
  end

  def update_password(password)
    self.update(password: password)
  end
end
