class WebhookController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :setup_user

  def telegram
    telegram = Telegram::Bot.new(params: params, telegram_bot_token: ENV['github_tg_bot_token'])

    case telegram.text
    when /start/i
      telegram.send_message(text: 'Thank you for using this bot!')
    when /login/i
      telegram.send_message(text: "Please press [GitHub](https://github.com/login/oauth/authorize?scope=user:email&client_id=#{ENV['github_client_id']}&redirect_uri=https://#{request.server_name}#{login_path(telegram.chat.id)}) to login.", parse_mode: 'markdown')
    end
  end

  private

    def setup_user
      User.first_or_create(user_params)
    end

    def user_params
      params.require(:message)
            .require(:from)
            .permit(:id,
                    :is_bot,
                    :first_name,
                    :last_name,
                    :username,
                    :language_code)
    end
end
