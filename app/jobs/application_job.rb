require 'line/bot'
class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked
  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError
  queue_as :default
  def perform(*args)
    limit_today= Date.today..Time.now.end_of_day + (1.days)
    customers = Customer.all
    customers.each do |customer|
      if customer.line_alert == true
        if routine.implementation_times.accurate_time.present?
          limit_items =  ExpendableItem.where(customer_id: customer.id).where(deadline_on: limit_today)
          if limit_items != []
            names = limit_items.map {|item| item.name }
            message = {
                  type: 'text',
                  text: "ルーティンのお時間だわよ！"
                }
            response = line_client.push_message(customer.uid, message)
            logger.info "PushLineSuccess"
          end
        end
      end
    end
  end

  private

  def line_client
    Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end
end
