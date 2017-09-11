require 'test_helper'
require 'user_monitor'

class ActiveRecordExtTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(name: 'test')
  end

  def current_user=(user)
    Thread.current[:user] = user
  end

  def teardown
    ShapeWithoutMonitor.delete_all
    Shape.delete_all
    User.delete_all
    Thread.current[:user] = nil
  end
  
  test "model without created_by / updated_by should not fail" do
    shape_without_monitor = ShapeWithoutMonitor.new(name: 'Square')
    assert shape_without_monitor.save
  end

  test "model without current_user" do
    shape = Shape.new(name: 'Circle')
    assert shape.save
    assert_nil shape.created_by, nil
    assert_nil shape.updated_by, nil
  end

  test "model with current_user" do
    self.current_user = @user
    shape             = Shape.new(name: 'Square')
    shape.save
    assert_equal shape.created_by, @user.id
    assert_equal shape.updated_by, @user.id
  end

  test "multiple updates" do
    self.current_user = @user
    shape             = Shape.new(name: 'Polygon')
    shape.save
    assert_equal shape.created_by, @user.id
    assert_equal shape.updated_by, @user.id

    user_2 = User.create!(name: 'Someone Else')
    self.current_user = user_2
    shape.name = 'Star'
    shape.save
    assert_equal shape.created_by, @user.id
    assert_equal shape.updated_by, user_2.id
  end

  test "when updated_by assigned before create" do
    self.current_user = @user
    assigned_user     = User.create!(name: 'user_something')
    shape             = Shape.new(name: 'Updated by Assigned',
                                  updated_by: assigned_user.id)
    shape.save
    assert_equal shape.created_by, @user.id
    assert_equal assigned_user.id, shape.updated_by
  end

  test "creator and updater without user" do
    shape = Shape.new
    assert_nil shape.creator
    assert_nil shape.updater
  end

  test "creator and updater with user" do
    self.current_user = @user
    shape             = Shape.create! name: 'shape'
    assert_equal shape.creator, @user
    assert_equal shape.updater, @user
  end
end
