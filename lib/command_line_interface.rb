def welcome
   puts "Welcome to the music quiz!"
end

def get_user_name
   puts "What's your name?"
   input = STDIN.gets.strip
   input
end

def check_user
   user_name = get_user_name
   #if new user
   if !User.find_by(name: user_name)
      User.create(name: user_name)
      puts "Awesome, nice to meet you, #{user_name}!"
      create_password(User.find_by(name: user_name))
    #else (existing user)
   else 
      puts "Welcome back, #{user_name}!"
      check_password(User.find_by(name: user_name))
   end
end

def check_password(user)
   puts "Please enter your password."   
   password = STDIN.gets.strip
   if user.password == password.to_i
      puts "Welcome back"
   elsif password == "exit"
      exit
   else 
      puts "Wrong password, try again"
      check_password(user)
   end
end

def create_password(user)
   puts "Please create new password."
   password = STDIN.gets.strip.to_i
   user.update(password: password)
end

