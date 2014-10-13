require 'optparse'

module Todo
  class Command

    module Options

      # コマンドライン引数をパース
      # @return [Hash] パース結果
      def self.parse!(argv)
        command_parser = OptionParser.new do |opt|
          opt.on_head('-v', '--version', 'Show program version') do |v|
            opt.version = Todo::VERSION
            puts opt.ver
            exit
          end
        end

        command_parser.parse!(argv)
      end

    end

  end
end
