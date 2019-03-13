require 'net/http'

class GithubController < ApplicationController
  before_action :setup_user

  def login
    github_params = github_params_format_from(user_info(params[:code]))
    user_github_create_or_update(user: @user, params: github_params)

    redirect_to github_index_path(user_id: @user.id)
  end

  def index
    @github = @user.github
  end

  private

    def setup_user
      @user = User.includes(github: :repos).find_by_id(params[:user_id])
    end

    def user_github_create_or_update(user:, params:)
      # init GitHub
      if user.github.blank?
        github = user.build_github(params)
        github.save
      else
        user.github.update(params)
      end

      # store repo
      url = "https://api.github.com/users/#{user.github.login}/repos"
      res = request_get(url: url)
      res_json = JSON.parse(res.body, :symbolize_names => true)
      res_json.each do |repo|
        repo_params = repo.slice( 
                                  :id,
                                  :node_id,
                                  :name,
                                  :full_name,
                                  :owner,
                                  :html_url,
                                  :description,
                                  :created_at,
                                  :updated_at
                                )
        user.github.update(github_params_format_from(repo_params[:owner]))
        github_repo_create_or_update(github: user.github, params: repo_params.except(:owner))
      end


      user.github
    end

    def github_repo_create_or_update(github:, params:)
      repo = github.repos.find_by_id(params[:id])
      if repo.blank?
        github.repos.create(params)
      else
        repo.update(params)
      end
    end

    def user_info(code)
      # Get access token
      url = 'https://github.com/login/oauth/access_token'
      parameter = {
        client_id: ENV['github_client_id'],
        client_secret: ENV['github_client_secret'],
        code: code
      }
      res = request_get(url: url, params: parameter)
      access_token = format_url_params(res.body)[:access_token]
      
      # Get user info
      url = "https://api.github.com/user?access_token=#{access_token}"
      res = request_get(url: url)

      JSON.parse(res.body, :symbolize_names => true)
    end

    def request_get(url:, **options)
      uri = URI(url)
      
      if options[:params].present?
        uri.query = URI.encode_www_form(options[:params]) 
      end
      
      Net::HTTP.get_response(uri)
    end
    
    def format_url_params(parameter)
      url_params = {}
      parameter.split('&').map do |param|
        key, value = param.split('=')
        url_params[key.to_sym] = value
      end
      url_params
    end

    def github_params_format_from(params)
      params.except( 
                      :type,
                      :url,
                      :followers_url,
                      :following_url,
                      :gists_url,
                      :starred_url,
                      :subscriptions_url,
                      :organizations_url,
                      :repos_url,
                      :events_url,
                      :received_events_url
                    )
    end
end
