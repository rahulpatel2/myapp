
class HomeController < ApplicationController
  def index
    if session[:user_id].nil?
      user = User.where("email = ? AND password = ?", params[:username], params[:password]).pluck(:id)
      if user.count == 0
        flash[:notice] = "Invalid Email or password"
        redirect_to '/' 
      end
      session[:user_id] = user[0]
    end
  end

  def logout
    reset_session
    redirect_to '/'
  end

  def send_email
    response = {}
    begin
      RestClient.post "https://api:key-3ax6xnjp29jd6fds4gc373sgvjxteol0"\
      "@api.mailgun.net/v3/samples.mailgun.org/messages",
      :from => "#{params['name']} <#{params['email']}>",
      :to => params['toemail'],
      :subject => params['subject'],
      :text => params['message']
      response['status'] = 1
    rescue Exception => e
      response['status'] = 0
    end
    render :json => response.to_json
  end

  def send_sms
    response = {}
    begin
      account_sid = 'AC289516feb708fad78a83eec5d82b329d'; 
      auth_token = '52b3af3e5b45d7bee309c4fb5bb9e2c2';
      # set up a client to talk to the Twilio REST API 
      @client = Twilio::REST::Client.new account_sid, auth_token 

      @client.account.messages.create({
        :from => "+18554725915", 
        :to => params['phone'], 
        :body => params['message'],  
      })
      response['status'] = 1
    rescue Exception => e
      response['status'] = 0
    end
    render :text => response.to_json
  end
end
