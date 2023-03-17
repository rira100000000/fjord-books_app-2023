# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  include Devise::Test::IntegrationHelpers

  setup do
    @report = reports(:one)
  end

  test '日報作成者が現在ログインしているユーザーであれば編集可能であること' do
    @user = users(:one)
    sign_in @user
    assert_equal true, @report.editable?(@user)
  end

  test '日報作成者が現在ログインしているユーザーでなければ編集不可能であること' do
    @user = users(:two)
    sign_in @user

    assert_equal false, @report.editable?(@user)
  end
end
