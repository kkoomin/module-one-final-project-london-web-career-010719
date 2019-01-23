$current_user = nil
#STDIN.noecho(&:gets).chomp <- no charater printed out

def welcome
   puts Rainbow("Welcome to the music quiz!").blink.orange
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
def start_menu 
   menu = TTY::Prompt.new
   brk
   selection = menu.select("") do |a|
      a.choice 'New Player'
      a.choice 'Existing Player'
      a.choice ' '
      a.choice 'Exit game'
    end

    if selection == 'New Player'
      create_account
    elsif selection == 'Existing Player'
      login_account
    elsif selection == "Exit game"
      exit
    else 
      puts "BOOOOOOM! It's A Trap!!! 💣"
      sleep 2
      start_menu
    end

end

def create_account #for '#start_menu'
   puts "Please enter your name"
   brk
   user_name = get_input

   if !User.find_by(name: user_name)
      user = User.create(name: user_name)
      puts "Awesome, nice to meet you, #{user_name}!"
      brk
      password = password_prompt('Please create new password.')
      user.update_password(password)  
      puts "Password Set!"
      return user
   else 
      puts "That name is taken. Please choose another one."
      create_account
   end
end
 
def login_account #for '#start_menu'
   puts "Please enter your name"
   brk
   user_name = get_input

   if User.find_by(name: user_name)
      puts "Welcome back, #{user_name}!"
      User.find_by(name: user_name).check_password
   else 
      menu = TTY::Prompt.new
      brk
      selection = menu.select("I can't find your name, wanna try again?") do |a|
         a.choice 'Try again'
         a.choice 'Back to menu'
      end
      if selection == 'Try again'
         login_account
      elsif selection == 'Back to menu'
         start_menu
      end

   end
end


def main_menu(user)
   menu = TTY::Prompt.new
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
   welcome
   $current_user = start_menu
   $current_user.artists.first ? $current_user.change_artists : $current_user.enter_artists
   main_menu($current_user)
end
