class Question

  attr_accessor :content, :artist, :answers
  @@all = []

  def initialize(artist)
    @artist = artist
    @content = "Name as many songs by #{artist} as you can!!!"
    @answers = top_track_names_from_artist(artist)
    @answered = []
  end

  def hidden_answers
    answers.first(20).map {|answer|
      if @answered.include?(answer)
        Rainbow(answer).green
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
    time_limit = 60
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
    input = get_input
    countdown = Time.now - question_time
      check_input(input)
      check_countdown(countdown, time_limit)
    end

  end

  def check_input(input)
    corrected_input = song_search_return_name(input, self.artist)
    if self.answers.include?(input)
      @answered << input
      update_board
      puts Rainbow("CORRECT").green
      brk
    elsif self.answers.include?(corrected_input)
      @answered << corrected_input
      update_board
      puts Rainbow("CORRECT").green
      brk
    else
      update_board
      puts Rainbow("INCORRECT").red
      brk
    end
  end

  def update_board
    50.times {brk}
    puts hidden_answers
    brk
    puts "SCORE: #{@answered.uniq.length}"
    brk
    puts content
    brk
  end

  def check_countdown(countdown, time_limit)
    if countdown > time_limit
      $current_user.add_score(@answered.count)
      puts "TIMES UP!"
      puts "You got #{@answered.count} songs!"
    
      back_or_exit
    else
      puts "You have #{time_limit - countdown.to_i} seconds left!"
    end
  end

end
