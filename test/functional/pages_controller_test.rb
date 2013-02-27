require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  test "should get why_vpn" do
    get :why_vpn
    assert_response :success
  end

  test "should get setup_howto" do
    get :setup_howto
    assert_response :success
  end

  test "should get login" do
    get :login
    assert_response :success
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get contactus" do
    get :contactus
    assert_response :success
  end

  test "should get faq" do
    get :faq
    assert_response :success
  end

end
