module Todo

  # コマンドラインベースの処理を行うクラスです
  # @author betahikaru
  class Command

    # メイン処理
    def execute
      DB.prepare
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

  end

end
