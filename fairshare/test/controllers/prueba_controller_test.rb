require "test_helper"

class PruebaControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get prueba_index_url
    assert_response :success
  end

  test "should get show" do
    get prueba_show_url
    assert_response :success
  end

  test "should get new" do
    get prueba_new_url
    assert_response :success
  end

  test "should get create" do
    get prueba_create_url
    assert_response :success
  end

  test "should get edit" do
    get prueba_edit_url
    assert_response :success
  end

  test "should get update" do
    get prueba_update_url
    assert_response :success
  end

  test "should get destroy" do
    get prueba_destroy_url
    assert_response :success
  end
end
