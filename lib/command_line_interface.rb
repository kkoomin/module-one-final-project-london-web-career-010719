$current_user = nil

def welcome
   puts "Welcome to the music quiz!"
end

def get_input
   input = STDIN.gets.strip
   input
end

def password_prompt(message, mask='*')
   ask(message) { |q| q.echo = mask}
end

def brk
  puts ""
end

# ///////////////////////////

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
      password = password_prompt('Please create new password.')
      user.update_password(password)  #STDIN.noecho(&:gets).chomp <- no charater printed out
      puts "Password Set!"
      return user
   else
      brk
      puts "Welcome back, #{user_name}!"
      User.find_by(name: user_name).check_password
   end
end

def main_menu(user)
   menu = TTY::Prompt.new
   # puts "Do you want to change the list of your artists?"
   brk
   selection = menu.select("MENU") do |a|
      a.choice 'Quiz'
      a.choice 'Rank'
      a.choice 'Popular Artists'
    end
    if selection == 'Quiz'
      Question.new(user.artists.sample.name).ask_loop
    elsif selection == 'Rank'
      puts "----HIGH SCORES----"
      puts rank
    end
end

def rank 
   users_arr = User.order(highscore: :desc)
   users_arr.limit(5).map do |i|
      "#{i.name} : #{i.highscore}"
   end
end




def init
   $current_user = welcome_user
   $current_user.artists.first ? $current_user.change_artists : $current_user.enter_artists
   main_menu($current_user)
end
