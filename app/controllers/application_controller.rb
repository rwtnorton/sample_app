class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper  # Makes these methods available in all
                          # controllers (in addition to all views).
end
