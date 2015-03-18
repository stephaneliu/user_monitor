module UserMonitor
  def self.included(base)
    base.class_eval do
      alias_method_chain :create, :user
      alias_method_chain :update, :user

      def current_user
        Thread.current[:user]
      end
    end
  end

  def create_with_user
    user = current_user
    if !user.nil?
      self[:created_by] = user.id if respond_to?(:created_by) && created_by.nil?
      self[:updated_by] = user.id if respond_to?(:updated_by) && updated_by.nil?
    end
    create_without_user
  end
  
  def update_with_user
    user = current_user
    self[:updated_by] = user.id if respond_to?(:updated_by) && !user.nil?
    update_without_user
  end
  
  def creator
    begin
      current_user.class.find(self[:created_by]) if current_user
    rescue ActiveRecord::RecordNotFound
      nil
    end
  end
 
  def updater
    begin
      current_user.class.find(self[:updated_by]) if current_user
    rescue ActiveRecord::RecordNotFound
      nil
    end
  end
end 
