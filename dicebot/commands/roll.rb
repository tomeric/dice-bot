module DiceBot
  module Commands
    class Roll < SlackRubyBot::Commands::Base
      operator '='
      command  'roll'
      
      def self.roll(text)
        begin
          result  = DiceBag::Roll.new(text).result
          label   = result.label ? "_#{result.label} total:_" : "_Total:_"
          total   = "*#{result.total}*"
          tally   = "(rolled: #{roll_values(result).join ', '})"
          options = "[#{roll_options(result).join ', '}]"
          
          return [label, total, tally, options].map(&:strip).join " "
        rescue => e
          return "'#{text}' is not a recognized roll format"
        end
      end
      
      def self.roll_values(result)
        rolls = result.sections.find_all { |s| s.is_a? DiceBag::RollPart }
        rolls.map(&:tally).flatten
      end
      
      def self.roll_options(result)
        result.sections.map do |roll|
          case roll
          when DiceBag::RollPart
            dice = "#{roll.count}d#{roll.sides}"
            options = roll.options.map do |key, value|
              humanize_option key, value
            end.compact.join ', '
            
            "#{dice} #{options.empty? ? '' : options}".strip
          when DiceBag::StaticPart
            roll.value >= 0 ? "+#{roll.value}" : "-#{roll.value}"
          else
            roll.to_s
          end
        end
      end
      
      def self.humanize_option(key, value)
        return unless value.to_i > 0
        
        dice = value > 1 ? "#{value} dice" : "die"
        
        case key
        when :explode
          "explode dice >= #{value}"
        when :drop
          "drop #{value} lowest #{dice}"
        when :keep
          "keep #{value} highest #{dice}"
        when :reroll
          "reroll dice <= #{value}"
        when :target
          "target total of #{value}"
        else
          "#{key}: #{value}"
        end
      end
      
      def self.call(client, data, match)
        text = match['expression'].strip
        
        if text.empty?
          message = "Please specify a roll (example `= d20` to roll a 20-sided die)"
        else
          commands = text.split('/').map &:strip
          message  = commands.map do |command|
            roll command
          end.join("\n")
          message.prepend "<@#{data.user}> rolled:\n"
        end
        
        client.say channel: data.channel, text: message
      end
    end
  end
end
