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
    puts "Please enter your password."
    brk
    input = get_input
     if self.password_checker(input) == true
       brk
       puts "Welcome back"
       return self
     elsif input.downcase == "exit"
       exit
     else
       brk
       puts "Wrong password, try again"
       check_password
     end
 end

 def enter_artists
  while self.artists.length < 5
    brk
    puts "Please enter your favourite artists."
    brk
    artist_name = check_artists(get_input)

    if !artist_name.nil?
       artist = Artist.find_by(name: artist_name)
       if artist.nil?
          self.artists << Artist.create(name: artist_name)
          puts "Got it! #{artist_name} has been added!"
       elsif self.artists.select{|a| a.id == artist.id}.first.nil?
          self.artists << artist
          puts "Got it! #{artist_name} has been added!!"
       else
          puts "You already have this artist!"
       end
    else
        brk
       puts "We can't find this #{artist_name}. Try again."
       enter_artists
    end

  end

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
       self.enter_artists #should be 5 times
     else
       puts "nah"
     end
 end

end
