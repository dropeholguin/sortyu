require 'test_helper'

class JustificationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @justification = justifications(:one)
  end

  test "should get index" do
    get justifications_url
    assert_response :success
  end

  test "should get new" do
    get new_justification_url
    assert_response :success
  end

  test "should create justification" do
    assert_difference('Justification.count') do
      post justifications_url, params: { justification: { body: @justification.body, photo: @justification.photo, title: @justification.title, user: @justification.user } }
    end

    assert_redirected_to justification_url(Justification.last)
  end

  test "should show justification" do
    get justification_url(@justification)
    assert_response :success
  end

  test "should get edit" do
    get edit_justification_url(@justification)
    assert_response :success
  end

  test "should update justification" do
    patch justification_url(@justification), params: { justification: { body: @justification.body, photo: @justification.photo, title: @justification.title, user: @justification.user } }
    assert_redirected_to justification_url(@justification)
  end

  test "should destroy justification" do
    assert_difference('Justification.count', -1) do
      delete justification_url(@justification)
    end

    assert_redirected_to justifications_url
  end
end
