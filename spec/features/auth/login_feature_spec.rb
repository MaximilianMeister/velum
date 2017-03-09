# frozen_string_literal: true
require "rails_helper"

feature "Login feature" do
  let!(:user) { create(:user) }

  before do
    visit new_user_session_path
  end

  scenario "It does not show any flash when accessing for the first time" do
    visit root_path
    expect(page).not_to have_content("You need to sign in or sign up before continuing.")
  end

  scenario "Existing user is able using his login and password to login into velum" do
    # We don't use Capybara's `login_as` method on purpose, because we are
    # testing the UI for logging in.
    fill_in "user_email", with: user.email
    fill_in "user_password", with: user.password
    find("input[type=submit]").click

    expect(page).to have_content("Configuration")
  end

  scenario "When guest tries to access dashboard - he is redirected to the login page" do
    visit root_path
    expect(page).to have_content("Log in")
  end

  scenario "User is redirected to the login page when trying to access a protected page" do
    visit setup_path
    expect(page).to have_content("You need to sign in or sign up before continuing.")
  end

  scenario "Successful login when trying to access a page redirects back the guest" do
    visit setup_path

    fill_in "user_email", with: user.email
    fill_in "user_password", with: user.password
    find("input[type=submit]").click

    expect(current_path).to eq setup_path
  end
end
