class MultipleChoice
    attr_accessor :content, :artist, :answer, :score
    @@all = []

    def initialize(artist)
        @artist = artist
        @content = "Choose #{artist.name}'s song!"
    end

    def set_question_and_check
        menu = TTY::Prompt.new
        @answer = @artist.top_x_tracks(30).shuffle.first #random album name string
        question = []
        question << @answer
        question << get_similar_artists_song
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
            $current_user.score += 5
            puts "Correct! You got 5 point!"
            sleep 2
        else
            brk
            puts "Wrong! Correct answer was #{@answer}!"
            sleep 2
        end
    end

    def get_similar_artists_song
        all_songs = @artist.similar_artists.map {|a| a.top_x_tracks(15)}.uniq # array of 4 artists's all songs
        one_songs = all_songs.map {|a| a.shuffle.first} # array of one songs randomly picked
    end

end
