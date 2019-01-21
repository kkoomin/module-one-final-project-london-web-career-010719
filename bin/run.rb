require_relative '../config/environment'
require_relative "../lib/api_communicator.rb"

Question.new.ask_loop

puts "Thanks for playing."
