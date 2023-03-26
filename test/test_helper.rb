# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def login
    @user = users(:user_taro)
    visit root_path
    fill_in 'Eメール', with: 'user1@example.com'
    fill_in 'パスワード', with: 'password'
    click_on 'ログイン'
    assert_selector 'h1', text: '本の一覧'
  end
end
