class User < ActiveRecord::Base
  has_many :user_artists
  has_many :artists, through: :user_artists

  def password_checker(password)
    password == self.password ?  true : false
  end

  def update_password(password)
    self.update(password: password)
  end

  def check_password
    brk
    password = password_prompt('Please enter your password.')
    brk
     if self.password_checker(password) == true
       brk
       puts "Welcome back"
       $current_user = self
       return main_menu($current_user)
     else
       brk
       menu = TTY::Prompt.new
        brk
        selection = menu.select("Wrong password, wanna try again?") do |a|
          a.choice 'Try again'
          a.choice 'Back to menu'
        end
        if selection == 'Try again'
          check_password
        elsif selection == 'Back to menu'
          start_menu
        end
     end
 end

 def enter_artists
   puts "Please enter one of your favourite artists."
   while self.artists.length < 5
    puts "We need #{5 - self.artists.length} more..." if self.artists.length < 5 && self.artists.length > 0
    brk
    artist_name = check_artists(get_input)

    if !artist_name.nil?
       artist = Artist.find_by(name: artist_name)
       if artist.nil?
          self.artists << Artist.create(name: artist_name)
          puts "Got it! #{artist_name} has been added!"
          brk
       elsif self.artists.select{|a| a.id == artist.id}.first.nil?
          self.artists << artist
          puts "Got it! #{artist_name} has been added!!"
          brk
       else
          puts "You already have this artist!"
       end
    else
        brk
       puts "We can't find this #{artist_name}. Try again."
       enter_artists
    end

  end
  sleep 1
  main_menu($current_user)
 end

 def change_artists
    prompt = TTY::Prompt.new
    # puts "Do you want to change the list of your artists?"
    brk
    selection = prompt.select("Do you want to change the list of your artists?") do |a|
       a.choice 'yes'
       a.choice 'no'
     end
     if selection == 'yes'
       self.artists.destroy_all
       self.enter_artists
     end
     main_menu($current_user)
 end


  def add_score(score)
    self.update(highscore: score) if self.highscore < score
  end

  def self.rank
    users_arr = self.order(highscore: :desc)
    table_data = users_arr.limit(5).map {|i| {:NAME => i.name, :SCORE => i.highscore}}
    Formatador.display_table(table_data)
  end

end
