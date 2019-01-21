class Question

  attr_accessor :content, :artist, :answers
  @@all = []

  def initialize
    @artist = get_top_artists_names.shuffle.first
    @content = "Name as many songs by #{artist} as you can!!!"
    @answers = top_track_names_from_artist(artist)
    @answered = []
  end

  def hidden_answers
    answers.first(15).map {|answer|
      if @answered.include?(answer)
        answer
      else
        answer.split.map {|x| x.gsub(/[^a-zA-Z0-9\-]/,"").first + "__"}.join("  ")
      end}
  end

  def ask_loop
    time_limit = 100
    input = nil
    question_time = Time.now

    50.times {brk}
    hidden_answers.each {|x| puts x}
    brk
    puts content
    input = nil

    while input != "exit"
    input = gets.strip
    countdown = Time.now - question_time
      check_input(input)
      check_countdown(countdown, time_limit)
    end

    brk
    answers.first(15).each{|x| puts x}
    brk
  end

  def brk
    puts ""
  end

  def check_input(input)
    if self.answers.include?(input)
      @answered << input
      50.times {puts ""}
      puts hidden_answers
      brk
      puts content
      brk
    else
      puts "#{input} is wrong!"
    end
  end

  def check_countdown(countdown, time_limit)
    if countdown > time_limit
      puts "TIMES UP"
    else
      puts "You have #{time_limit - countdown.to_i} seconds left!"
    end
  end

end
