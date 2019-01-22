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
    answers.first(20).map {|answer|
      if @answered.include?(answer)
        answer
      else
        answer.split.map {|x|
          if  x.length == 1 || x.length == 2 || x.downcase == "the" 
            x
          else
            x.gsub(/[^a-zA-Z0-9\-]/,"").first + "__"
          end}.join("  ")
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
    brk
    brk
    input = nil

    while input != "exit"
    input = gets.strip
    countdown = Time.now - question_time
      check_input(input)
      check_countdown(countdown, time_limit)
    end

    brk
    answers.first(20).each{|x| puts x}
    brk
  end

  def brk
    puts ""
  end

  def check_input(input)
    corrected_input = song_search_return_name(input)
    if self.answers.include?(input)
      @answered << input
      update_board
      puts "CORRECT"
      brk
    elsif self.answers.include?(corrected_input)
      @answered << corrected_input
      update_board
      puts "CORRECT"
      brk
    else
      update_board
      puts "INCORRECT"
      brk
    end
  end

  def update_board
    50.times {brk}
    puts hidden_answers
    brk
    puts "SCORE: #{@answered.length}"
    brk
    puts content
    brk
  end

  def check_countdown(countdown, time_limit)
    if countdown > time_limit
      puts "TIMES UP"
      puts "You got #{@answered.count} songs! You score is #{score_storage}"
    else
      puts "You have #{time_limit - countdown.to_i} seconds left!"
    end
  end

end
