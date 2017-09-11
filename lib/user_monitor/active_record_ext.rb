module UserMonitor
  extend ActiveSupport::Concern

  included do
    before_create :create_with_user, if: :current_user?
    before_save   :update_with_user, if: :current_user?
  end

  def current_user
    Thread.current[:user]
  end

  def current_user?
    current_user.present?
  end

  def create_with_user
    write_attribute('created_by', current_user.id) if created_by_assignable?
    write_attribute('updated_by', current_user.id) if updated_by_assignable?
  end
  
  def update_with_user
    write_attribute('updated_by', current_user.id) if updated_by_assignable?
  end
  
  def creator
    begin
      current_user.class.find(read_attribute('created_by')) if current_user
    rescue ActiveRecord::RecordNotFound
      nil
    end
  end
 
  def updater
    begin
      current_user.class.find(read_attribute('updated_by')) if current_user
    rescue ActiveRecord::RecordNotFound
      nil
    end
  end

  private

  def created_by_assignable?
    respond_to?(:created_by=) && created_by.blank?
  end

  def updated_by_assignable?
    respond_to?(:updated_by=) && (new_record? ? updated_by.blank? : true)
  end
end 
