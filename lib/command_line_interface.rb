def welcome
   puts "Welcome to the music quiz!"
end

def get_input
   input = STDIN.gets.strip
   input
end

def welcome_user
  welcome
  puts "Please enter your name"
  user_name = get_input
  if !User.find_by(name: user_name)
      user = User.create(name: user_name)
      puts "Awesome, nice to meet you, #{user_name}!"
      puts "Please create new password."
      user.update_password(get_input)
      puts "Password Set"
   else
      puts "Welcome back, #{user_name}!"
      check_password(User.find_by(name: user_name))
   end
end

def check_password(user)
   puts "Please enter your password."
   input = get_input
    if user.password_checker(input) == true
      puts "Welcome back"
    elsif input.downcase == "exit"
      exit
    else
      puts "Wrong password, try again"
      check_password(user)
    end
end
