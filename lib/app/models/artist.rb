class Artist < ActiveRecord::Base
  has_many :user_artists
  has_many :users, through: :user_artists

  def artist_name
    self.name.gsub(" ", "%20").mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,'')
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
    table_data = artists.sort {|a,b| b.users.count <=> a.users.count}.first(10).map{|a| {:NAME => a.name, :Players => a.users.count}}
    Formatador.display_table(table_data)
  end

  def similar_artists
    parse = JSON.parse(RestClient.get("http://ws.audioscrobbler.com/2.0/?method=artist.getsimilar&artist=#{artist_name}&api_key=#{$api_key}&format=json"))
    parse = parse["similarartists"]["artist"].map {|m| m["name"]}.shuffle.first(4)
    parse.map{|name| Artist.new(name: name)}
  end

end
