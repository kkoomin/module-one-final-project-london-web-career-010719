class MultipleChoice
    attr_accessor :content, :artist, :answer, :score
    @@all = []
    
    def initialize(artist)
        @artist = artist
        @content = "Choose #{artist.name}'s song!"
    end

    def set_question_and_check
        menu = TTY::Prompt.new
        @answer = @artist.top_x_tracks(20).last(10).shuffle.first #random album name string
        question = []
        question << @answer
        question << get_top_tracks.shuffle.first(4)
        dropdown = question.flatten!.shuffle

        selection = menu.select(" 🎧  #{@content}") do |q|
            brk
            q.choice "#{dropdown[0]}"
            q.choice "#{dropdown[1]}"
            q.choice "#{dropdown[2]}"
            q.choice "#{dropdown[3]}"
            q.choice "#{dropdown[4]}"
        end

        if selection == @answer
            brk
            $current_user.score += 3
            puts Rainbow("Correct!").green + " You got " + Rainbow("3").green + " points!"
            sleep 2
        else
            brk
            puts Rainbow("Wrong!").red + " It was " + Rainbow("#{@answer}").red + "!"
            sleep 2
        end
    end

end
