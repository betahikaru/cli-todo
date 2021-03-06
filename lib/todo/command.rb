module Todo

  # コマンドラインベースの処理を行うクラスです
  # @author betahikaru
  class Command

    # コマンドから実行するインタフェース
    # @param [Array] argv
    def self.run(argv)
      new(argv).execute
    end

    # コンストラクタ
    # @param [Array] argv
    def initialize(argv)
      @argv = argv
    end

    # メイン処理
    def execute
      options  = Options.parse!(@argv)
      sub_command = options.delete(:command)

      DB.prepare

      tasks =
        case sub_command
          when 'create'
            create_task(options[:name], options[:content])
          when 'delete'
            delete_task(options[:id])
          when 'update'
            update_task(options.delete(:id), options)
          when 'search'
            find_tasks(options[:status])
        end

      display_tasks tasks

    end

    # タスクの新規作成
    # @param [String] name
    # @param [String] content
    def create_task(name, content)
      # statusはデフォルト(NOT_YET)
      Task.create!(name: name, content: content).reload
    end

    # タスクの削除
    # @param [Integer] id
    # @throws ActiveRecord::RecordNotFound
    def delete_task(id)
      task = Task.find(id)
      task.destroy
    end

    # タスクの更新
    # @param [Integer] id
    # @param [Hash] attributes
    # @throws ActiveRecord::RecordNotFound
    def update_task(id, attributes)
      # :statusを数値に変換
      if attributes[:status]
        status_name = attributes[:status]
        attributes[:status] = Task::STATUS.fetch(status_name.upcase)
      end

      task = Task.find(id)
      task.update_attributes!(attributes)

      task.reload
    end

    # タスクの一覧取得
    def find_tasks(status_name)
      all_tasks = Task::order(created_at: :desc)

      if status_name
        status = Task::STATUS.fetch(status_name.upcase)
        all_tasks.status_is(status)
      else
        all_tasks
      end
    end

    # tableの内容を出力する
    def display_tasks(tasks)
      header = display_format('ID', 'Name', 'Content', 'Status')

      puts header
      puts '-' * header.size
      Array(tasks).each do |task|
        puts display_format(task.id, task.name, task.content, task.status_name)
      end
    end

    # 1つのTaskの出力を整形する
    def display_format(id, name, content, status)
      [
        id.to_s.rjust(4),
        name.ljust(20),
        content.ljust(38),
        status.ljust(8)
      ].join(' | ')
    end

  end

end
