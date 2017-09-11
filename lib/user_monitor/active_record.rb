ActiveSupport.on_load :active_record do
  include UserMonitor
end
