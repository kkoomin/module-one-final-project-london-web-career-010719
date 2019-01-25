def cat_animation

15.times do
  i = 1
  while i < 3
    system("clear")
    print "\033[2J"
    File.foreach("/Users/flatiron/Documents/Mod 1/module-one-final-project-guidelines-london-web-career-010719/lib/ascii_animation/#{i}.rb") { |f| puts f }
    sleep(0.2)
    i += 1
  end
  i = 1
end
end
