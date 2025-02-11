class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
    getWeek
    @plan = Plan.new
  end

  # 予定の保存
  def create
    Plan.create(plan_params)
    redirect_to action: :index
  end

  private

  def plan_params
    params.require(:plan).permit(:date, :plan)
  end

	def getWeek
    #0が（日）〜6が（土）と添字で管理し wdaysといった配列に格納
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']

    # 今日の日付を取得して@todays_dateに格納
    @todays_date = Date.today
    
　　#1週間分の日付と予定を格納するための配列
    @week_days = []
	#wherメソッドを使ってplanテーブル内のdateカラム（今日の日付から+6日したdataを取得）したものを変数plansに格納
    plans = Plan.where(date: @todays_date..@todays_date + 6)
		
	#1週間分の日付についてループ処理を行う
    7.times do |x|
		today_plans = [] #予定を格納する配列
#plansに入っている（今日の日付から+6日したdataを取得)をeachを使い、もしplan の日付とループで見ている日が＝（一致）していた時
#today_plansにpushメソッドを使ってif文の条件で確認されtoday_plans に追加される
#要するに特定の日付に対するすべての予定が today_plans に蓄積される
      plans.each do |plan| 
        today_plans.push(plan.plan) if plan.date == @todays_date + x
      end
		
#@todays_date + xは基準日からx日後の日付.wdayメソッドその日付の曜日を返す→変数wday_numに格納
		wday_num = (@todays_date + x).wday
#「wday_numが7以上の場合」という条件式
		if wday_num >= 7
#wday_numが7以上である場合、1週間分（7）を引いて曜日の数値を再調整
        wday_num = wday_num - 7
		end
#wdays[wday_num]は、wdays配列の中からwday_numに対応する曜日の文字列を取得し、それをハッシュのwdayキーに格納します。
      days = { month: (@todays_date + x).month, date: (@todays_date+x).day, plans: today_plans, wday: wdays[wday_num]}
#今日の日付情報とその日の予定、曜日を`@week_days`配列に追加
 @week_days.push(days)
    end
  end
end