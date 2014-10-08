require 'active_record'

module Todo

  # tasksテーブルのモデルクラス
  # モデルのクラス名は単数形
  # モデルクラスはActiveRecord::Baseを継承する
  # @author betahikaru
  class Task < ActiveRecord::Base

    NOT_YET = 0 # タスク未完了
    DONE    = 1 # タスク完了済
    PENDING = 2 # タスク保留状態

    # 状態のの文字列と数値をマッピングして定数化
    STATUS = {
      'NOT_YET' => NOT_YET,
      'DONE' => DONE,
      'PENDING' => PENDING
    }.freeze
  end

end