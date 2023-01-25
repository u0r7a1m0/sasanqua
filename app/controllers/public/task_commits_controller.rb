class Public::TaskCommitsController < ApplicationController
  def create
    # チェックがないSubTaskのIDを検索して完了しているかチェックする
    # 完了しているものをレコードとしてSubTaskCommitに保存する
    # RoutingのShowにredirect_to
  end
end
