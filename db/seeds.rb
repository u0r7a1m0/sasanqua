# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

admins = [
 {email: 'nagano@cake', password: 'bookers'},
]
admins.each do |admin|
 admin_data = Admin.find_by(email: admin[:email])
 if admin_data.nil?
  Admin.create(email: admin[:email], password: admin[:password])
 end
end

# routine_customer = Customer.find_by(email: 'naho@com')

# enumの条件式を配列データーに変換する
# enumの値忘れたので、値を入れて使って下さい。
def times_select(frequency)
  if frequency == 'threeday_once'
    [3, 1]
  elsif frequency == 'twoday_once'
    [2, 1]
  elsif frequency == 'oneday_third'
    [1, 3]
  elsif frequency == 'oneday_twice'
    [1, 2]
  else
    [1, 1]
  end
end

def periods_select(period)
 if period == 'everyday'
  [0]
 elsif period == 'one_week'
  [1]
 elsif period == 'two_week'
   [2]
 elsif period == 'three_week'
   [3]
 elsif period == 'four_week'
   [4]
 elsif period == 'one_month'
   [5]
 else
   [6]
 end
end

customers = [
 {email: 'ai@com', password: 'bookers', nickname: "愛"},
 {email: 'naho@com', password: 'bookers', nickname: "なほ"},
 {email: 'momo@com', password: 'bookers', nickname: "momo"},
 {email: 'kei@com', password: 'bookers', nickname: "Kay"},
 {email: 'sou@com', password: 'bookers', nickname: "ソウ"},
]
customers.each do |customer|
 customer_data = Customer.find_by(email: customer[:email])
 if customer_data.nil?
  Customer.create(email: customer[:email], password: customer[:password], nickname: customer[:nickname])
 end
end

  #ランダム要素として使う時間数これは１２時間から２４００時間の間をランダムに生成
  hour_range = rand(12..2400)
  #ルーティンを登録 created_at の値はnowの時間から hour_range 分前に戻す。他カラム適当なので修正して下さい。
  routine = customer.routines.create!(col: "", col: "", created_at: Time.zone.now.ago(hour_range.hour))
  #頻度の登録。has_oneは create_カラム名 で登録。 frequency: rand(1..5)の部分はenumのキーの数の範囲をランダムで入れます。
  frequency = routine.create_frequency!(col: "", frequency: rand(1..5))
  #他モデル名忘れたので、上を参考に書き入れて下さい。特にランダムにする要素はなかったと思います。
  implementation_time = routine.create_implementation_time!(col: "", col: "")
  period = routine.create_period!(col: "", period: rand(1..7))

  #登録した頻度を最初に作ったメソッドに入れて数値化します。
  count_one = times_select(frequency.frequency)
  count_two = periods_select(period)

  #1~3回のランダムでタスクを生成。
  rand(1..3).times do |nn|
    #taskを作ります。
    task = routine.create_task!(name: "maintask#{nn+1}")
    #ここは、hour_rangeを２４で割って、頻度の何日毎の部分である、count[0]で割って、ルーティンの登録日から、頻度分飛ばしてレコードさせます。
    (hour_range / 24 / count[0]).times do|nnn|
      #一日複数回用のループです。
      count[1].times do
        #commitのレコードに不規則性をもたせるので、特に意味のない乱数を作ります。
        random_number = rand(0..2)
        #コミットを作成します。乱数が0以外の時に、created_atに現在日時から遡って頻度分レコードさせます。
        task.task_commits.create!(created_at: Time.zone.now.ago((nnn)*count[0].day))
      end
    end
  end
  #sub_taskを作ります。
rand(1..3).times do |nn|
  #taskを作ります。上と全く同じです。
  task = routine.create_task!(name: "main_task_name#{nn}")
  #ここからサブタスクです。 ランダムに１〜３回作ります。
  rand(1..3).times do |nnn|
    #サブタスクを作ります。カラム名適当なので、修正して下さい。
    sub_task = task.sub_tasks.create!(name: "sub_task_name#{nnn+1}")
    #ここは、hour_rangeを２４で割って、頻度の何日毎の部分である、count[0]で割って、ルーティンの登録日から、頻度分飛ばしてレコードさせます。
    (hour_range / 24 / count[0]).times do|nnnn|
      count[1].times do
        #commitのレコードに不規則性をもたせるので、特に意味のない乱数を作ります。
        random_number = rand(0..2)
        #コミットを作成します。乱数が0以外の時に、created_atに現在日時から遡って頻度分レコードさせます。
        sub_task.task_commits.create!(created_at: Time.zone.now.ago((nnnn)*(count[0]).day)) if random_number != 0
      end
    end
  end
end