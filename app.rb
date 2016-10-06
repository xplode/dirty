require 'sinatra'
require 'open3'

class TheApp < Sinatra::Base
  get '/' do
    msg = "dirtygirty"
    code = params[:code].to_i || 200
    sleep(params[:sleep].to_i) if params[:sleep]
    msg = params[:echo] if params[:echo]
    halt code, msg 
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
