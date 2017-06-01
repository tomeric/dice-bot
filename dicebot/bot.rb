module DiceBot
  class Bot < SlackRubyBot::Bot
    help do
      title 'Dice Bot'
      desc 'This bot rolls dice.'
      
      command 'roll' do
        desc 'Roll unlimited amount of multi-sided dice'
        long_desc <<~DESC
        Here are some examples:
        
        `= d20`
          Rolls a single 20-sided die
        
        `= 4d6`
          Rolls 4 6-sided dice
        
        `= 1d6e6` [Explode]
          Rolls a 6-sided dice, if the number rolled is greater than or equal to 6, the die is rolled again and added to the total
        
        `= 4d6d1` [Discard]
          Rolls 4 6-sided dice and discards lowest die
        
        `= 4d6k3` [Keep]
          Rolls 4 6-sided dice and keep the best 3 values 
        
        `= 4d12r2` [Reroll]
          Rolls 4 12-sided dice and rerolls 1s and 2s
        
        `= 1d20+10t15` [Target]
          Rolls a 20-sided die, adds 10, returns 1 if result is greater than or equal to 15
        
        `= d20+11 / d20+6 / d20+1`
          Rolls 3 times and returns all rolls separately
        DESC
      end
    end
  end
end
