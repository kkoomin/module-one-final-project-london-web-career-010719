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
        question << get_top_tracks
        dropdown = question.flatten!.shuffle

        selection = menu.select(" 🎧  #{@content}") do |q|
            q.choice "#{dropdown[0]}"
            q.choice "#{dropdown[1]}"
            q.choice "#{dropdown[2]}"
            q.choice "#{dropdown[3]}"
            q.choice "#{dropdown[4]}"
        end

        if selection == @answer
            brk
            $current_user.score += 3
            puts Rainbow("Correct! You got 3 point!").green
            sleep 2
        else
            brk
            puts Rainbow("Wrong! It was #{@answer}!").red
            sleep 2
        end
    end

end
