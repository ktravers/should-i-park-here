class SendTextController < ApplicationController
  skip_before_action :verify_authenticity_token

  def sms
    minute_to_move = params[:full_date_time]['hour(5i)']
    hour_to_move = params[:full_date_time]['hour(4i)'].to_i
    am_pm = 'am'
    (hour_to_move -= 12; am_pm = 'pm') if hour_to_move > 12

    twilio_sid = Rails.application.secrets.twilio_sid
    twilio_token = Rails.application.secrets.twilio_token
    @twilio_client = Twilio::REST::Client.new twilio_sid, twilio_token

    @twilio_client.account.sms.messages.create(
      from: "+1#{Rails.application.secrets.twilio_number}",
      to: params[:number],
      body: "Don't forget to move your car! It's parked at #{params[:address]}. Move it by #{hour_to_move}:#{minute_to_move} #{am_pm} on #{params[:day]}.")
    respond_to do |f|
      f.html
      f.js
    end
  end
end
