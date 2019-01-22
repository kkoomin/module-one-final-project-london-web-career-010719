def welcome
   puts "Welcome to the music quiz!"
end

def get_input
   input = STDIN.gets.strip
   input
end

def brk
  puts ""
end

def welcome_user
  brk
  welcome
  brk
  puts "Please enter your name"
  brk
  user_name = get_input
  if !User.find_by(name: user_name)
      user = User.create(name: user_name)
      puts "Awesome, nice to meet you, #{user_name}!"
      brk
      puts "Please create new password."
      user.update_password(get_input)
      puts "Password Set"
      return user
   else
      brk
      puts "Welcome back, #{user_name}!"
      User.find_by(name: user_name).check_password
   end
end

def init
   user = welcome_user
   user.artists.first ? user.change_artists : user.enter_artists
   Question.new(user.artists.sample.name).ask_loop
end
