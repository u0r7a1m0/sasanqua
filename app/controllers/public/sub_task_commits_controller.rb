class Public::SubTaskCommitsController < ApplicationController
  def create
    @routine = Routine.find(params[:routine_id])
    hindo = @routine.frequency.frequency
    sub_task_1 = params[:sub_task_1][:SubTask] if params[:sub_task_1].present?
    sub_task_2 = params[:sub_task_2][:SubTask] if params[:sub_task_2].present?
    sub_task_3 = params[:sub_task_3][:SubTask] if params[:sub_task_3].present?
    sub_task_1.delete("") if params[:sub_task_1].present?
    sub_task_2.delete("") if params[:sub_task_2].present?
    sub_task_3.delete("") if params[:sub_task_3].present?
    
    # commits1 = SubTaskCommit.where(sub_task_id: sub_task_1[0])
    # commits2 = SubTaskCommit.where(sub_task_id: sub_task_1[1])


    # チェックされたデータがあるかどうか
    # byebug
    # params[sub_task_1] => "38"
    # params[sub_task_2] => "38"
    # params[]
    # 29day 15:05
    # @routineは ■うでたて　□うでたて

    # sub_task_commit id:1 sub_task_id:38 times: 1　created_at 29day
    # # @routineの頻度は1日1回だったら

    # @routineのコミットDB今なんこあるか(げんざいじこく)
    # @routineの頻度
    
    ####################
    #if　①.チェックされたデータがあるかどうか
      #if ②.sub_task_idがDBに存在していて、かつcreate_atが今日（翌日5:00）かどうか
        
        #if　③.「sub_task_2」が存在するなら
          #if　3-2.「sub_task_3」が存在する場合は以下実行（1日3回の人）（commit1& 3& 2）
            # DBから「sub_task_commit」データを持ってきて、全部をうわがきする
            # commit1 = SubTaskCommit.find_by(times: 1)
            # commit2 = SubTaskCommit.find_by(times: 2)
            # commit3 = SubTaskCommit.find_by(times: 3)
            commit2 = SubTaskCommit.new if commmit2.nil?
            commit2.sub_task_id = params[:sub_task_id]
            commit2.sub_task_id.nil? ? commit2.destroy : commit2.save
          #end
          # 3がないなら以下実行（1日2回の人）（commit1&2）
          
          
        
        #else　3-3.その他全部（commit1）
          #saveする
      
        #end
        
        
      #else　3-3.その他全部（データが存在してないから、creatしてあげる
        #saveする(timesもせっとしてあげる)

      #end
        
    
    #end
      
      
    # end



   ####################
    if @routine.task.sub_task.id.present?
      redirect_to routine_path(@routine.id)
    else
      render :show
    end
    # 完了しているものをレコードとしてSubTaskCommitに保存する
    # RoutingのShowにredirect_to
  end



  def destroy

  end
end
