require 'net/http'

class GithubController < ApplicationController
  def login
    @user = User.find_by_id(params[:user_id])
    github_params = access_token(params[:code])
    @github = user_github_create_or_update(user: @user, params: github_params)
  end

  private

    def user_github_create_or_update(user:, params:)
      if user.github.blank?
        user.build_github(params)
      else
        user.github.update(params)
      end

      user.github
    end

    def access_token(code)
      # Get access token
      url = 'https://github.com/login/oauth/access_token'
      parameter = {
        client_id: ENV['github_client_id'],
        client_secret: ENV['github_client_secret'],
        code: code
      }
      res = request_get(url: url, params: parameter)
      access_token = format_url_params(res.body)['access_token']

      # Get user info
      url = "https://api.github.com/user?access_token=#{access_token}"
      res = request_get(url: url)
      
      JSON.parse(res.body).except("type",
                                  "url",
                                  "followers_url",
                                  "following_url",
                                  "gists_url",
                                  "starred_url",
                                  "subscriptions_url",
                                  "organizations_url",
                                  "repos_url",
                                  "events_url",
                                  "received_events_url")
    end

    def request_get(url:, **options)
      uri = URI(url)

      if options[:params].present?
        uri.query = URI.encode_www_form(options[:params]) 
      end

      ::Net::HTTP.get_response(uri)
    end

    def format_url_params(parameter)
      url_params = {}
      parameter.split('&').map do |param|
        key, value = param.split('=')
        url_params[key] = value
      end
      url_params
    end
end
