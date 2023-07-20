require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = User.new(username: 'testing1', first_name: 'tester', last_name: 'tester', password: '12345678', email: 'test@example.com')
  end

  test 'creating a user with and without proper attributes' do
    assert_difference('User.count') do
      post api_users_path, params: { user: { username: 'testing1', first_name: 'first_name', last_name: 'last_name', password: 'test@example.com', email: 'test@example.com' } }
    end

    assert_difference('User.count', 0) do
      post api_users_path, params: { user: { username: 'testing1', first_name: 'first_name', last_name: 'last_name', password: 'psafdsf', email: 'test@example.com' } }
    end
  end

  test "should get index" do
    @user.save
    token = sign_in_as(@user)

    get api_users_path, headers: { Authorization: token }

    assert_response :success
  end

  test 'should not be able to get all the index if not logged in' do
    get api_users_path

    assert_response 401
  end

  test 'should get new' do
    get new_api_user_path

    assert_response :success
  end

  test 'should get show for one user' do
    @user.save
    token = sign_in_as(@user)

    get api_user_path(@user), headers: { Authorization: token }

    assert_response :success
  end

  test 'should not be able to show one user if not their own' do
    @user.save
    @user2 = User.create(username: 'testing2', first_name: 'tester', last_name: 'tester', password: '12345678', email: 'test2@example.com')

    token = sign_in_as(@user)

    get api_user_path(@user2), headers: { Authorization: token }

    assert_response 401
  end

  test 'should get the edit page for one user' do
    @user.save
    token = sign_in_as(@user)
    get edit_api_user_path(@user), headers: { Authorization: token }

    assert_response :success
  end

  test 'should be able to update their user' do
    @user.save
    token = sign_in_as(@user)

    put api_user_path(@user), headers: { Authorization: token }, params: { user: { first_name: 'testing', password: '12345678' } }

    assert_response :success
  end

  test 'should not be able to update the user that is not theirs' do
    @user.save
    @user2 = User.create(username: 'testing2', first_name: 'tester', last_name: 'tester', password: '12345678', email: 'test2@example.com')

    token = sign_in_as(@user)

    put api_user_path(@user2), headers: { Authorization: token }, params: { user: { first_name: 'testing', password: '12345678' } }

    assert_response 401
  end

  test 'should not delete the user if it is not theirs' do
    @user.save
    token = sign_in_as(@user)
    @user2 = User.create(username: 'testing2', first_name: 'tester', last_name: 'tester', password: '12345678', email: 'test2@example.com')
    delete api_user_path(@user2), headers: { Authorization: token }

    assert_response 401
  end

end
