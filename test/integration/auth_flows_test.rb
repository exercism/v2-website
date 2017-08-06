require 'test_helper'

class AuthFlowsTest < ActionDispatch::IntegrationTest
  test "password log in respects page you were on" do
    password = "foobar"
    user = create :user, password: password

    track = create :track
    get track_path(track)
    assert_response :success

    post user_session_path, params: {user: {email: user.email, password: password}}

    assert_redirected_to track_path(track)
    assert_response :redirect
    follow_redirect!

    assert_redirected_to my_track_path(track)
  end

  test "password sign up respects page you were on" do
    password = "foobar"
    user = create :user, password: password

    track = create :track
    get track_path(track)
    assert_response :success

    post "/users", params: {user: {
      name: "Jo Bloggs", handle: SecureRandom.uuid, email: "#{SecureRandom.uuid}@asdasda.com",
      password: "foobar", password_confirmation: "foobar"
    }}

    assert_redirected_to track_path(track)
    assert_response :redirect
    follow_redirect!

    assert_redirected_to my_track_path(track)
  end

  test "oauth log in respects page you were on" do
    provider = "foobar"
    uid = "12321321"
    user = create :user, provider: provider, uid: uid

    track = create :track
    get track_path(track)
    assert_response :success

    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
      provider: provider, uid: uid
    })

    post user_github_omniauth_callback_path

    assert_redirected_to track_path(track)
    assert_response :redirect
    follow_redirect!

    assert_redirected_to my_track_path(track)
  end

  test "oauth sign up respects page you were on" do
    provider = "foobar"
    uid = "12321321"

    track = create :track
    get track_path(track)
    assert_response :success

    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
      provider: provider, uid: uid,
      info: {
        nickname: SecureRandom.uuid, email: "#{SecureRandom.uuid}@erwerew.com", name: "qwe asd", image: "http://a.com/j.jpg"
      }
    })

    post user_github_omniauth_callback_path

    assert_redirected_to track_path(track)
    assert_response :redirect
    follow_redirect!

    assert_redirected_to my_track_path(track)
  end

  test "password sign up joins track" do
    password = "foobar"
    user = create :user, password: password

    track = create :track
    get track_path(track)
    assert_response :success

    post join_track_path(track)
    assert_response :redirect
    follow_redirect!

    email = "#{SecureRandom.uuid}@asdasda.com"
    post "/users", params: {user: {
      name: "Jo Bloggs", handle: SecureRandom.uuid, email: email,
      password: "foobar", password_confirmation: "foobar"
    }}

    assert_redirected_to track_path(track)
    assert_response :redirect
    follow_redirect!

    assert_redirected_to my_track_path(track)

    user = User.find_by_email!(email)
    assert_equal [track], user.tracks
  end

  test "oauth sign up joins track" do
    provider = "foobar"
    uid = "12321321"
    email = "#{SecureRandom.uuid}@erwerew.com"

    track = create :track
    get track_path(track)
    assert_response :success

    post join_track_path(track)
    assert_response :redirect
    follow_redirect!

    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
      provider: provider, uid: uid,
      info: {
        nickname: SecureRandom.uuid, email: email, name: "qwe asd", image: "http://a.com/j.jpg"
      }
    })

    post user_github_omniauth_callback_path

    assert_redirected_to track_path(track)
    assert_response :redirect
    follow_redirect!

    assert_redirected_to my_track_path(track)

    user = User.find_by_email!(email)
    assert_equal [track], user.tracks
  end
end
