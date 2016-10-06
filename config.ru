require 'rubygems'
require 'sinatra'
require 'logger'
require File.expand_path '../app.rb', __FILE__

APP_DIR = Dir.pwd
LOGFILE = File.join(APP_DIR, "dirtygirty.log")
configure do
  LOGGER = Logger.new(LOGFILE)
  enable :logging, :dump_errors
  set :raise_errors, true
end

run TheApp
