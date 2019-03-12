class GithubController < ApplicationController
  def login
    @user = User.find_by_id(params[:user_id])
    @user.update(github_token: params[:code])
  end
end
