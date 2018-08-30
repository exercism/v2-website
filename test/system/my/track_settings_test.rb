require 'application_system_test_case'

class My::TrackSettingsTest < ApplicationSystemTestCase
  setup do
    Git::ExercismRepo.stubs(current_head: "dummy-sha1")
    @user = create(:user,
                  accepted_terms_at: Date.new(2016, 12, 25),
                  accepted_privacy_policy_at: Date.new(2016, 12, 25))
    BootstrapUser.(@user)
    sign_in!(@user)
  end

  test "can navigate to track settings" do
    visit my_settings_path
    assert page.has_link?(href: my_settings_track_settings_path)
    click_on "Track Settings"
    assert_current_path my_settings_track_settings_path
  end

  test "can set track to use anonymous handle" do
    @user_track = create(:user_track, user: @user)
    anon_handle = SecureRandom.uuid

    visit my_settings_track_settings_path

    assert_not_equal true, @user_track.anonymous
    find("tr[data-track=#{@user_track.track.title}] input[type=checkbox]", visible: false).click
    find("tr[data-track=#{@user_track.track.title}] input[type=text]", visible: false).set(anon_handle)

    click_on "Update privacy settings"

    assert_selector "#notice", text: "Your track settings have been updated" 

    @user_track.reload
    assert_equal true, @user_track.anonymous
    assert_equal anon_handle, @user_track.handle
  end

  test "can set track to stop using anonymous handle" do
    @user_track = create(:user_track, user: @user)
    anon_handle = SecureRandom.uuid
    @user_track.update_attributes(anonymous: true, handle: anon_handle)

    visit my_settings_track_settings_path

    assert_equal true, @user_track.anonymous
    find("tr[data-track=#{@user_track.track.title}] input[type=checkbox]", visible: false).click

    click_on "Update privacy settings"

    assert_selector "#notice", text: "Your track settings have been updated" 

    @user_track.reload
    assert_not_equal true, @user_track.anonymous
  end
end
