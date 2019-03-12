namespace :dev do
  desc "Generate Necessary File"
  task set_up: :environment do
    configs = %w[application database]
    configs.each do |config|
      `cp config/#{config}.yml.example config/#{config}.yml`
      puts "Copy #{config}.yml Finish"
    end
  end
end