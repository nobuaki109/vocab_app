require "test_helper"

class StudyHistoriesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get study_histories_create_url
    assert_response :success
  end

  test "should get index" do
    get study_histories_index_url
    assert_response :success
  end
end
