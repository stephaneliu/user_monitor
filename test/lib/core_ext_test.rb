require 'test_helper'
require 'user_monitor'

class CoreExtTest < ActiveSupport::TestCase
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
  end
  
  def test_model_without_created_by_updated_by_should_not_fail
    shape_without_monitor = ShapeWithoutMonitor.new(name: 'Square')
    assert shape_without_monitor.save
  end

  def test_model_without_current_user
    shape = Shape.new(name: 'Circle')
    assert shape.save
    assert_equal shape.created_by, nil
    assert_equal shape.updated_by, nil
  end

  def test_model_with_current_user
    self.current_user = @user
    shape             = Shape.new(name: 'Square')
    shape.save
    assert_equal shape.created_by, @user.id
    assert_equal shape.updated_by, @user.id
  end

  def test_multiple_updates
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

  def test_convenience_without_user
    shape = Shape.new
    assert_nil shape.creator
    assert_nil shape.updater
  end

  def test_creator_with_user
    self.current_user = @user
    shape             = Shape.create! name: 'shape'
    assert_equal shape.creator, @user
    assert_equal shape.updater, @user
  end
end
