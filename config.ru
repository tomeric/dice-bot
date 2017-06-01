$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'dotenv'
Dotenv.load

require 'dicebot'
require 'web'

Thread.abort_on_exception = true

Thread.new do
  begin
    DiceBot::Bot.run
  rescue Exception => e
    STDERR.puts "ERROR: #{e}"
    STDERR.puts e.backtrace
    raise e
  end
end

run DiceBot::Web
