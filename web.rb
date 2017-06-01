require 'sinatra/base'

module DiceBot
  class Web < Sinatra::Base
    get '/' do
      'Dice are good for you.'
    end
  end
end