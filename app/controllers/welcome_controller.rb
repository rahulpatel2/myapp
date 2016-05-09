class WelcomeController < ApplicationController
  def index
  end

  def login
    user = User.new(first_name: params[:firstname], last_name: params[:lastname], email: params[:email], password: params[:passwd])
    if user.valid?
      user.save 
    else
      logger.debug("invalid user register data")
      logger.flush
    end
    redirect_to '/'
  end
end
