require 'io/console'
require 'artii'
require 'unimidi'
require 'colorize'
require 'colorized_string'


class User
  def initialize(name, record)
    @name = name
    @record = record
  end

  def self.all
    ObjectSpace.each_object(self).to_a.sort
  end

  attr_accessor :name, :record
end

def bad_sound
  notes = [15] # C E G arpeggios
  duration = 0.3
  output = UniMIDI::Output.open(:first)
  output.open do |output|
    notes.each do |note|
      output.puts(0x90, note, 100) # note on message
      sleep(duration)  # wait
      output.puts(0x80, note, 100) # note off message
    end
  end
end

def game_over_sound
  notes = [15,16,15,15,16,15] # C E G arpeggios
  duration = 0.4
  output = UniMIDI::Output.open(:first)
  output.open do |output|
    notes.each do |note|
      output.puts(0x90, note, 100) # note on message
      sleep(duration)  # wait
      output.puts(0x80, note, 100) # note off message
    end
  end
end

def intro_sound
  notes = [15,14,15,13,17,13,13,14,15,15,12,15,15,14,13,13,13,13, 13, 13, 14, 15, 15, 12, 15, 15, 14, 13, 13, 17, 13, 15, 14, 15] # C E G arpeggios
  duration = 0.1
  output = UniMIDI::Output.open(:first)
  output.open do |output|
    notes.each do |note|
      output.puts(0x90, note, 100) # note on message
      sleep(duration)  # wait
      output.puts(0x80, note, 100) # note off message
    end
  end
end

def go_sound
  notes = [80] # C E G arpeggios
  duration = 1
  output = UniMIDI::Output.open(:first)
  output.open do |output|
    notes.each do |note|
      output.puts(0x90, note, 100) # note on message
      sleep(duration)  # wait
      output.puts(0x80, note, 100) # note off message
    end
  end
end

def artiify(content)
  a = Artii::Base.new :font => 'slant'
  puts a.asciify(content)
end

def continue_or_quit
  quit = STDIN.getch.downcase
  if quit == "q"; system "cls"; exit end
end

def tryagain_or_quit
  tryagain = STDIN.getch.downcase
  if tryagain == 'c'; system "cls"; exit end
end

def count_down
  i = 4
  system "cls"
  4.times { |x| i-=1; puts "\n" * 15 ; artiify("              #{i}"); sleep(1); system "cls"}
  go_sound
end

system "cls"
puts"\n" * 15
artiify(" Trumpersist")
intro_sound
puts"\n"*4
puts "                     Continue or quit with Q"
continue_or_quit

time_idle_to_sleep = 15

quit = 'a'
while quit != 'q' do

system "cls"
puts "\n" * 4
puts "                Press any key to start Trumpersisting"
STDIN.getch
count_down

time0 = Time.now
time1 = Time.now
puts"\n" * 4
puts "            Press any key every 15 seconds to Trumpersist!!!".colorize(:green)

thread_iloop = Thread.new do
  loop do
    reset = STDIN.getch
    if reset != nil; time1 = Time.now end
  end
end

thread_text = Thread.new do
  text = File.open('persistence.txt', 'r')
  key_words_red = ['terrorism', 'riots', 'fight', 'immigration', 'radical', 'crime', 'war', 'defeat', 'against', 'attack', 'death', 'bad', 'never', 'violence', 'judgment', 'worst', 'killed', 'fighting', 'enforcement', 'dead', 'killings', 'terrorists', 'reject', 'violent', 'destruction', 'hatred', 'corrupt', 'invasion', 'hurt', 'pursue', 'terrorist', 'stop', 'corruption', 'attacks', 'anti', 'judgement', 'aggressively', 'sanctions', 'threat', 'defeated', 'illegal', 'terror', 'killing', 'dangerous', 'evil', 'force', 'lawlessness','no','not', 'military', 'stupid', 'disaster', 'weapons', 'crass', 'stupidity']
  key_words_green = ['love']
  speed = rand(0.1..0.3)
  puts "\n" * 2
  text.read.split(/\b/).each do |x|
    if  key_words_red.include?(x.downcase) ; print "#{x}".colorize(:red); bad_sound
    elsif key_words_green.include?(x.downcase) ; print "#{x}".colorize(:green)
    else print "#{x}" ; sleep(speed)  end
  end
  intro_sound
  system "cls"
  puts "\n" * 10
  time_idle_to_sleep = 20
  puts "      We never expected someone to TRUMPERSITS this FAR!!!!\n\n"
  puts "    You must be Donald's Family or Friends or Donanld himself?\n\n\n"
  puts "                          In any case\n\n\n\n\n\n"
  artiify("    YOU LOSE!!")
  puts "\n" * 2
  puts "            your are being tranfered to the leader board"
end

until Time.now - time1 > time_idle_to_sleep do
#Could add background music here
end

Thread.kill( thread_text )
Thread.kill( thread_iloop )

if Time.now - time1 > time_idle_to_sleep; game_over_sound end
system "cls"


if Time.now - time0 < 60
  record = (Time.now - time0).round
  unit = "secs"
else
  record = ((Time.now - time0) / 60).round(2)
  unit = "mins"
end

puts"\n" * 4

puts "                  You Trumpersited #{record} #{unit}!!".colorize(:green)


puts "\n        Show off your Trumpersistence in the Leaderboard"
puts "\n\n                      enter your name:"
your_name = gets.chomp.to_s

User.new(your_name, record)
leaderboard = File.open("leaderboardTrumpersist.txt", 'a+')
User.all.each do |user|
    leaderboard.write("\n#{user.name.capitalize}, trumpersisted: #{user.record} #{unit}\n")
end

leaderboard.rewind
puts "\n\n\n                           LEADERBOARD\n".colorize(:green)
puts "   *".colorize(:green) * 16
puts leaderboard.read
leaderboard.close

puts "\n\n\n            Press Q to quit  or any other key to try again"
continue_or_quit

end
