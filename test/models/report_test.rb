# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  include Devise::Test::IntegrationHelpers

  setup do
    @report = reports(:report1)
  end

  test '日報作成者が現在ログインしているユーザーであれば編集可能であること' do
    @user = users(:user_taro)
    sign_in @user
    assert_equal true, @report.editable?(@user)
  end

  test '日報作成者が現在ログインしているユーザーでなければ編集不可能であること' do
    @user = users(:user_nameless)
    sign_in @user

    assert_equal false, @report.editable?(@user)
  end

  test '日報の作成日をdate型で取得できること' do
    assert_equal Time.zone.today, @report.created_on
  end
end
