require 'user_monitor/core_ext'

ActiveRecord::Base.class_eval do
  include UserMonitor
end
