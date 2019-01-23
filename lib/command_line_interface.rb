$current_user = nil
#STDIN.noecho(&:gets).chomp <- no charater printed out

def welcome
   brk
   brk
   brk
   system("artii 'Music Quiz' --font slant")
   brk
   brk
   brk
   puts Rainbow("🎵  Choose your Favourite Artists and Solve the Quiz!  🎵").red
   brk
end

def get_input
   input = STDIN.gets.strip
   input.length == 0 ? " " : input
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
      system("artii 'B O O M !' | lolcat -a")
      puts "💣 It's A Trap!!! 💣"
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
      $current_user = user
      $current_user.enter_artists 
      main_menu($current_user)
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
   selection = menu.select("MAIN MENU") do |a|
      a.choice 'Quiz'
      a.choice 'High Scores'
      a.choice 'Popular Artists'
      a.choice 'Update your Artists'
      a.choice 'Change User'
      a.choice 'Exit Game'
    end

   if selection == 'Quiz'
      #progress bar
      total    = 1000
      progress = Formatador::ProgressBar.new(total, :color => "light_blue")
      puts "Creating your Quiz!"
      1000.times do
      sleep 0.001
      progress.increment
      end
      #
      Question.new(user.artists.sample.name).ask_loop
   elsif selection == 'High Scores'
      puts "----HIGH SCORES----"
      puts User.rank
      back_or_exit
   elsif selection == 'Popular Artists'
      puts "----Popular Artists----"
      puts Artist.popular
      back_or_exit
   elsif selection == 'Update your Artists'
      user.change_artists
   elsif selection == 'Exit Game'
      exit
   elsif selection == 'Change User'
      $current_user = nil
      start_menu
   end

end

def back_or_exit
   menu = TTY::Prompt.new
   selection = menu.select("") do |a|
      a.choice 'Back to Main Menu'
      a.choice 'Exit Game' 
   end
    main_menu($current_user) if selection == 'Back to Main Menu'
    exit if selection == 'Exit Game'
end

def rank 
   users_arr = User.order(highscore: :desc)
   users_arr.limit(5).map do |i|
      "#{i.name} : #{i.highscore}"
   end
end


def init
   welcome
   start_menu
end
