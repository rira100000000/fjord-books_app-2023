# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  include Devise::Test::IntegrationHelpers

  test '日報作成者は作成した日報を編集可能であること' do
    report = reports(:report1)
    user = users(:user_taro)

    assert_equal true, report.editable?(user)
  end

  test '日報作成者以外は日報を編集不可能であること' do
    report = reports(:report1)
    user = users(:user_nameless)

    assert_equal false, report.editable?(user)
  end

  test '日報の作成日をdate型で取得できること' do
    report = reports(:report1)

    assert_equal Time.zone.today, report.created_on
  end
end
