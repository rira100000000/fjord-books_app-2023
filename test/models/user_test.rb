# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'ユーザーの名前が設定されているとき、名前を取得できること' do
    user = users(:one)
    assert_equal '一人目太郎', user.name_or_email
  end

  test 'ユーザーの名前が設定されていないとき、メールアドレスを取得できること' do
    user = users(:two)
    assert_equal 'user2@example.com', user.name_or_email
  end
end
