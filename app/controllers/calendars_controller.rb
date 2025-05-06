class CalendarsController < ApplicationController
  WEEKDAYS = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)'].freeze

  # １週間のカレンダーと予定が表示されるページ
  def index
    fetch_week_calendar
    @plan = Plan.new
  end

  # 予定の保存
  def create
    Plan.create(plan_params)
    redirect_to action: :index
  end

  private

  def plan_params
    params.require(:calendars).permit(:date, :plan)
  end

  def fetch_week_calendar
    @todays_date = Date.today
    @week_days = []

    plans = Plan.where(date: @todays_date..@todays_date + 6)

    7.times do |day_index|
      current_date = @todays_date + day_index
      today_plans = plans.select { |plan| plan.date == current_date }.map(&:plan)
      
      @week_days.push(
        month: current_date.month,
        date: current_date.day,
        plans: today_plans
      )
    end
  end
end
