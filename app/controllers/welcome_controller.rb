class WelcomeController < ApplicationController
  def index
  end

  def login
    user = User.new(first_name: params[:firstname], last_name: params[:lastname], email: params[:email], password: params[:passwd])
    user.save if user.valid?
    render 'index'
  end
end
