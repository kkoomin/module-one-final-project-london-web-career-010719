class Question

  attr_accessor :content, :artist, :answers
  @@all = []

  def initialize
    @artist = get_top_artists.shuffle.first
    @content = "Name as many songs by #{artist} as you can!!!"
    @answers = top_track_names_from_artist(artist)
  end

  def ask_loop
    time_limit = 60
    answered = []
    question_time = Time.now
    puts content
    input = nil
    while input != "exit"
    input = gets.strip
    countdown = Time.now - question_time

      if self.answers.include?(input)
        answered << input
        20.times {puts ""}
        puts content
        answered.each {|e| puts  "  -  " + e +  "  -  "}
        puts
      else
        puts "#{input} is wrong!"
      end

      if countdown > time_limit
        puts "TIMES UP"
        break
      else
        puts "You have #{time_limit - countdown.to_i} seconds left!"
      end
    end
    puts "Thanks for playing."
  end

end
