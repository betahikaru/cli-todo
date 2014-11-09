require 'optparse'

module Todo
  class Command

    module Options

      # コマンドライン引数をパース
      # @return [Hash] パース結果
      def self.parse!(argv)
        # 未定義のサブコマンドをエラーにする
        sub_command_parsers = Hash.new do |hash, key|
          raise ArgumentError, "'#{key}' is not todo sub command."
        end

        parsed_options = {}

        # サブコマンドの引数を定義
        sub_command_parsers['create'] = OptionParser.new do |opt|
          opt.on('-n VAL', '--name=VAL', 'task name') do |v|
            parsed_options[:name] = v
          end
          opt.on('-c VAL', '--content=VAL', 'task content') do |v|
            parsed_options[:content] = v
          end
        end
        sub_command_parsers['search'] = OptionParser.new do |opt|
          opt.on('-s VAL', '--search=VAL', 'search status') do |v|
            parsed_options[:status] = v
          end
        end
        sub_command_parsers['update'] = OptionParser.new do |opt|
          opt.on('-n VAL', '--name=VAL', 'update name') do |v|
            parsed_options[:name] = v
          end
          opt.on('-c VAL', '--content=VAL', 'update content') do |v|
            parsed_options[:content] = v
          end
          opt.on('-s VAL', '--search=VAL', 'update status') do |v|
            parsed_options[:status] = v
          end
        end
        sub_command_parsers['delete'] = OptionParser.new do |opt|
          # no options
        end
        # サブコマンド以外の引数を定義
        command_parser = OptionParser.new do |opt|
          opt.on_head('-v', '--version', 'Show program version') do |v|
            opt.version = Todo::VERSION
            puts opt.ver
            exit
          end
        end

        begin
          command_parser.order!(argv)

          # サブコマンド名
          parsed_options[:command] = argv.shift

          sub_command_parsers[parsed_options[:command]].parse!(argv)
        rescue OptionParser::MissingArgument, OptionParser::InvalidOption, ArgumentError => e
          abort e.message
        end

        parsed_options
      end

    end

  end
end
