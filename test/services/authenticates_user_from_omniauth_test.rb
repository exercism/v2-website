require 'test_helper'

class AuthenticatesUserFromOmniauthTest < ActiveSupport::TestCase
  test "logs in with existing details" do
    provider = "foobar"
    uid = "bizzzz"
    user = create :user, provider: provider, uid: uid

    auth = mock(provider: provider, uid: uid)
    actual = AuthenticatesUserFromOmniauth.authenticate(auth)
    assert_equal user, actual
  end

  test "works with correct details" do
    provider = "foobar"
    uid = "bizzzz"
    email = "asdas@asdasda.com"
    name = "asda adsdsa"
    handle = "asdqweqwewqe"
    avatar_url = "http://asdadhasa.com/jasds.jpg"

    info = mock
    info.stubs(email: email, name: name, nickname: handle, image: avatar_url)
    auth = mock
    auth.stubs(provider: provider, uid: uid, info: info)

    user = AuthenticatesUserFromOmniauth.authenticate(auth)
    assert user.persisted?
    assert_equal provider, user.provider
    assert_equal uid, user.uid
    assert_equal email, user.email
    assert_equal name, user.name
    assert_equal handle, user.handle
    assert_equal avatar_url, user.avatar_url
  end

  test "logs in with same email" do
    user = create :user

    info = mock
    info.stubs(email: user.email)
    auth = mock(provider: "asda", uid: "12312", info: info)
    actual = AuthenticatesUserFromOmniauth.authenticate(auth)
    assert_equal user, actual
  end

  test "chooses free handle if it's not unique" do
    handle = "asdqweqwewqe"
    num1 = 8833
    num2 = 2134

    info = mock
    info.stubs(nickname: handle, email: "asd@erwerew.com", name: "qwe asd", image: "http://a.com/j.jpg")
    auth = mock
    auth.stubs(provider: "qwe", uid: "asdasa", info: info)

    create :user, handle: handle
    create :user, handle: "#{handle}-#{num1}"

    SecureRandom.stubs(:random_number).with(10000).returns(num1, num2)
    user = AuthenticatesUserFromOmniauth.authenticate(auth)
    assert user.persisted?
    assert_equal "#{handle}-#{num2}", user.handle
  end

  test "does not updates email if it's not @users.noreply.github.com" do
    provider = "foobar"
    uid = "bizzzz"
    old_email = "foo@users1.noreply.github.com"
    user = create :user, provider: provider, uid: uid, email: old_email

    auth = mock(provider: provider, uid: uid, info: mock(email: "dog@cat.com"))
    actual = AuthenticatesUserFromOmniauth.authenticate(auth)
    assert_equal user, actual

    user.reload
    assert_equal old_email, user.email
  end

  test "updates email if it's @users.noreply.github.com" do
    provider = "foobar"
    uid = "bizzzz"
    new_email = "dog@cat.com"
    user = create :user, provider: provider, uid: uid, email: "foo@users.noreply.github.com"

    auth = mock(provider: provider, uid: uid, info: mock(email: new_email))
    actual = AuthenticatesUserFromOmniauth.authenticate(auth)
    assert_equal user, actual

    user.reload
    assert_equal new_email, user.email
  end
end
