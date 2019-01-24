class Question

  attr_accessor :content, :artist, :answers
  @@all = []

  def initialize(artist)
    @artist = artist
    @content = "Name as many songs by #{artist} as you can!!!"
    @answers = top_track_names_from_artist(artist)
    @answered = []
  end

  def ask_loop
    time_limit = 15#(seconds)
    input = nil
    question_time = Time.now

    big_brk
    hidden_answers.each {|x| puts x}
    brk
    puts content
    brk
    brk

    until Time.now - question_time > time_limit
      puts "You have #{time_limit - (Time.now - question_time).to_i} seconds left!"
      input = get_input
      check_input(input)
      brk
    end
      $current_user.add_score(@answered.count)
      puts $pastel.red.bold("TIMES UP! ⏰")
      brk
      puts "You got #{@answered.count} songs!"
      brk
      answer_or_back_or_exit
  end


  def hidden_answers
    answers.first(20).map {|answer|
      if @answered.include?(answer)
        Rainbow(answer).green
      else
        answer.split.map {|x|
          if  x.length == 1 || x.length == 2 || x.downcase == "the" || x.downcase == "and"
            x
          else
            x.gsub(/[^a-zA-Z0-9\-]/,"").first + "-" + x[2..-1].gsub(/[abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]/,"┈")
          end}.join("  ")
      end}
  end


  def print_answers 
    answers.first(20).map do |answer|
      if @answered.include?(answer)
        Rainbow(answer).green
      else
        Rainbow(answer).red
      end
    end.each {|x| puts x}
    brk
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
    big_brk
    puts hidden_answers
    brk
    puts "SCORE: #{@answered.uniq.length}"
    brk
    puts content
    brk
  end

  def answer_or_back_or_exit
    menu = TTY::Prompt.new
    selection = menu.select("") do |a|
      a.choice 'Check the answers'
      a.choice 'Back to Main Menu'
      a.choice 'Exit Game'
    end

    if selection == 'Check the answers'
      big_brk
      print_answers
      back_or_exit
    elsif selection == 'Back to Main Menu'
      main_menu($current_user)
    else 
      exit
    end
  end

end