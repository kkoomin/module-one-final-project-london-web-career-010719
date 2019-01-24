class Artist < ActiveRecord::Base
  has_many :user_artists
  has_many :users, through: :user_artists

  def artist_name
    self.name.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,'').gsub(/[!@#^&*()=+|;':"<>?']/, '').gsub(" ", "%20")
  end

  def top_x_tracks(x)
    parse = JSON.parse(RestClient.get("http://ws.audioscrobbler.com/2.0/?method=artist.gettoptracks&artist=#{artist_name}&limit=#{x}&api_key=#{$api_key}&format=json"))
    if parse["toptracks"]
      return parse["toptracks"]["track"].map {|m| m["name"]}
    else
      return []
    end
  end

  def albums
    parse = JSON.parse(RestClient.get("http://ws.audioscrobbler.com/2.0/?method=artist.gettopalbums&artist=#{artist_name}&api_key=#{$api_key}&format=json"))
    parse["topalbums"]["album"].map {|m| m["name"]}
  end

  def self.popular
    artists = Artist.all
    table_data = artists.sort {|a,b| b.users.count <=> a.users.count}.first(10).map{|a| {:NAME => a.name, :Players => a.users.count}}
    Formatador.display_table(table_data)
  end

  def similar_artists
    parse = JSON.parse(RestClient.get("http://ws.audioscrobbler.com/2.0/?method=artist.getsimilar&artist=#{artist_name}&api_key=#{$api_key}&format=json"))
    if parse["similarartists"]
      return parse["similarartists"]["artist"].map {|m| m["name"]}.first(4).map{|n| Artist.new(name: n)}
    else
      return []
    end
  end


end
