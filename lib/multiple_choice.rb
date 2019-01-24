class MultipleChoice
    attr_accessor :content, :artist, :answers
    @@all = []

    def initialize(artist)
        @artist = artist
        @content = "Choose #{artist}'s album!"
        @answer = answer
        @answered = []
    end

    def set_question_and_check
        menu = TTY::Prompt.new
        @artist = $current_user.artists.shuffle.first #artist instance
        @answer = @artist.albums.shuffle.first #random album name string
        question = []
        question << @answer

  
        selection = menu.select("#{@content}") do |q|
            q.choice 
            q.choice 
            q.choice 
            q.choice 
            q.choice 
        end

    end

    def get_similar_artists_album
        all_albums = @artist.similar_artists.map {|a| a.albums } # array of 4 artists's all albums
        one_albums = all_albums.map {|a| a.shuffle.first} 
    end

    def show_album_artist

    end

    def add_score_multi

    end







end