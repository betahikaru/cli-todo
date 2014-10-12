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

  end

end
