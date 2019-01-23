class Artist < ActiveRecord::Base
  has_many :user_artists
  has_many :users, through: :user_artists

  def artist_name
    self.name.gsub(" ", "%20")
  end

  def top_x_tracks(x)
    parse = JSON.parse(RestClient.get("http://ws.audioscrobbler.com/2.0/?method=artist.gettoptracks&artist=#{artist_name}&limit=#{x}&api_key=#{$api_key}&format=json"))
    parse["toptracks"]["track"].map {|m| m["name"]}
  end

  def albums
    parse = JSON.parse(RestClient.get("http://ws.audioscrobbler.com/2.0/?method=artist.gettopalbums&artist=#{artist_name}&api_key=#{$api_key}&format=json"))
    parse["topalbums"]["album"].map {|m| m["name"]}
  end

  def self.popular
    artists = Artist.all
    artists.sort {|a,b| b.users.count <=> a.users.count}.first(5).map{|a| "#{a.name} : #{a.users.count}"}
  end

end
