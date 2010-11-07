require File.dirname(__FILE__) + '/../test_helper'
require 'site_controller'

class SiteController
  def rescue_action e
    raise e
  end
end

class SiteControllerTest < ActionController::TestCase
  def setup
    @controller = SiteController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
  end

  def test_index
    get :index
    title = assigns(:title)
    assert_response :success
    assert_template "index"
  end

  def test_about
    get :about
    title = assigns(:title)
    assert_response :success
    assert_template "about"
  end

  def test_help
    get :help
    title = assigns(:title)
    assert_response :success
    assert_template "help"
  end
  
  test "the truth" do
    assert true
  end
end
