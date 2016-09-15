# Notification Service in sinatra

Service will send email and after sending email service will call callback service to update notification status

## Install

1. Clone the directory 

  ```
  $ git clone https://github.com/teamoptimus/notification_service.git
  ```

2. bundle install

  ```
  $ bundle install
  ```

3. Install rabbitmq -

  Installing on Mac OS X using Homebrew -

  ```
  $ brew install rabbitmq
  ```

  Installing on Debian / Ubuntu -

  ```
  $ sudo apt-get install rabbitmq-server
  ```

  Installing on RPM-based Linux (CentOS, Fedora, OpenSuse, RedHat) -
 
  https://www.rabbitmq.com/install-debian.html


4. Start rabbitmq
  
  ```
  brew services start rabbitmq
  ```


## Configuration

1. Set `api_token` and `callback_service_url` in config/app_config.yml

  Sample configuration -

  ```ruby
  api_token: '6a8a858b7a070d7fb42cf6c057a1dc6b'
  callback_service_url: '.saral.com:3000/api/notification/update'
  ```


2. Set `tenant` and `smtp` options in config/mail_config.yml

  Sample configuration -

  ```ruby
  mail:
    tester02:
      address: "smtp.gmail.com"
      mail_port: 587
      domain: "localhost"
      user_name: "sender.email2016@gmail.com"
      password: 'sender123'
      authentication: "plain"
      enable_starttls_auto: true
  ```

3. Set `queue` and `threads` in config/queue_config.yml

 Sample configuration -

  ```ruby
  host: localhost
  port: 15672
  queue: "rabbitmq"
  queues:
    test:
      min_threads: 5
      max_threads: 5
      max_queue: 100
  ```


## Run App

rackup -p 4567

## Service

1. Send Notification -
    
    Sample Request =>
    ```ruby

      body = {}
      body['user'] = {}
      body['user']['employee_id'] = 'xx'
      body['user']['name'] = 'xxx'
      body['user']['email'] = 'xxx@mail.com'
      body['user']['password'] = 'xxxxxxxxxxxxxx'
      body['user']['reciever_email'] = 'xxxxxxxx@mail.com'
      body['user']['sender_email'] = 'noreply@mail.com'
      body['user']['subject'] = 'Login details'
      body['tv_sec'] = 'xxxxxxxxxx'
      body['type'] = 'email'
      body['tenant'] = 'default'
      body['transaction_id'] = SecureRandom.hex
      body['template'] = 'login_details'

      Use net/http to call Api -

      uri = URI.parse("http://localhost:4567/send")
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.request_uri)
      request.add_field 'AUTHORIZATION_TOKEN', 'xxxxxxxxxxxxxx'
      request.set_form_data({"body" => body.json})
      http.request(request)

    ```
   
    Sample Response in Positive cases =>

    ```json
    {
    "status":200,
    "message":"success"
    }
    ```


    Sample Response in Negative cases -

    (1) In case of body is null or  missing 
    ```json
    {
    "status":400,
    "message":"Invalid Request : message body is null"
    }
    ```

    (2) In case of template name is missing
    ```json
    {
    "status":400,
    "message":"Invalid Request : template is null or invalid"
    }
    ```
    (3) In case of tenant is invalid or nil 
    ```json
    {
    "status":400,
    "message":"Invalid Request : tenant is null or invalid"
    }
    ```
    (4) In case of Invalid Token  
    ```json
    {
    "status":401,
    "message":"Invalid Authentication Token"
    }
    ```
    (5)  Not able to create session to rabbitmq or Error in Publishing message in rabbitmq 
    ```json
    {
    "status":500,
    "message":"failure"
    }
    ```


## Copyright

Copyright (c) 2016 Cybrilla Technologies.


