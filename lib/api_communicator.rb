require 'rest-client'
require 'json'
require 'pry'

$api_key = "4d19d52e509a4fab0c5bdf0f538ed2a3"

def get_top_tracks
  JSON.parse(RestClient.get("http://ws.audioscrobbler.com/2.0/?method=chart.gettoptracks&api_key=#{$api_key}&format=json"))
end

def top_tracks_from_artist(artist)
  JSON.parse(RestClient.get("http://ws.audioscrobbler.com/2.0/?method=artist.gettoptracks&artist=#{artist}&api_key=#{$api_key}&format=json"))
end
