namespace :telegram do
  desc "Set webhook url"
  task :webhook, :url, :method_name do |task, args|
    url = [args.url, args.method_name].join('/')
    Telegram::Bot::SetWebhook(url: url, token: ENV['telegram_bot_token'])
    puts url
  end
end