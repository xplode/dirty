require 'sinatra'
require 'open3'
require File.expand_path '../generate.rb', __FILE__

class TheApp < Sinatra::Base
  

  get '/' do
    text = ''
    if !params[:echo] && !params[:generate]
      text = <<-HERE
        <center>
          <h3>Welcome to dirty girty, your dirty little webapp</h3>
        </center>
        You can pass the following query parameters to the root route / 
        (this is the route you are at) to modify girty's response.
        <ul> 
         <li>code= The http response code girty will return.
         <li>echo= Text girty will echo back verbatim.
         <li>generate= An positive integer that seeds a randomly generated webpage.
              The generated page will have as many unique images as the integer given. 
              When used in conjuction with echo the echo text will be pre-pended to 
              the body of the webpage.
         <li>clear_generated= Delete all generated html files. 
         <li>sleep= The number of seconds girty should wait to respond.
        </ul>
        <br>
        The following control and log paths are available:
        <ul>
         <li>restart Restart the girty app, useful after an update. 
         <li>update Get the latest software for girty. 
         <li>app_logs Get the girty app log file. 
         <li>apache_access_logs Get apache access logs. 
         <li>apache_error_logs Get apache error logs. 
        </ul>
      HERE
    end

   
    if params[:generate]
      text = Generate.get_html(Random.new(params[:generate].to_i))
    end

    if params[:echo] && !params[:generate]
      result = params[:echo]
    else
      result = <<-HERE
      <!DOCTYPE html>
        <html>
        <head>
        <title>Dirty Girty</title>
        </head>
        <body>
          #{params[:echo]}
          #{text}
        </body>
      HERE
    end

    sleep(params[:sleep].to_i) if params[:sleep]

    code = params[:code] || 200

    halt code.to_i, result 
  end

  get '/clear_generated' do
    msg = ""
    code = 200
    Open3.popen2e("rm #{APP_DIR}/generated/*.html") {|stdin, stdout_and_stderr, wait_thr|
      pid = wait_thr.pid # pid of the started process.
      exit_status = wait_thr.value # Process::Status object returned.
      msg = "#{stdout_and_stderr.read}: #{exit_status}" 
      code = 500 if exit_status != 0
    }
    halt code, msg 
  end

  get '/generate/:num' do
    text = Generate.get_html(Random.new(params[:num].to_i))
  end

  get '/app_logs' do
    File.read(LOGFILE)
  end

  get '/apache_access_logs' do
    File.read('/var/log/apache2/access.log')
  end

  get '/apache_error_logs' do
    File.read('/var/log/apache2/error.log')
  end

  get '/restart' do
    msg = ""
    code = 200
    Open3.popen2e("touch #{APP_DIR}/tmp/restart.txt") {|stdin, stdout_and_stderr, wait_thr|
      pid = wait_thr.pid # pid of the started process.
      exit_status = wait_thr.value # Process::Status object returned.
      msg = "#{stdout_and_stderr.read}: #{exit_status}" 
      code = 500 if exit_status != 0
    }
    halt code, msg 
  end

  get '/update' do
    msg = ""
    code = 200
    Open3.popen2e("git pull") {|stdin, stdout_and_stderr, wait_thr|
      pid = wait_thr.pid # pid of the started process.
      exit_status = wait_thr.value # Process::Status object returned.
      msg = "#{stdout_and_stderr.read}: #{exit_status}" 
      code = 500 if exit_status != 0
    }
    halt code, msg 
  end
end
