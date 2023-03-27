# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  setup do
    login
  end

  test 'visiting the index' do
    visit reports_url
    assert_selector 'h1', text: '日報の一覧'
  end

  test 'should create report' do
    visit reports_url
    click_on '日報の新規作成'

    fill_in 'タイトル', with: 'テストの学習をしました'
    fill_in '内容', with: '自動テストは素晴らしいです'
    click_on '登録する'

    assert_text '日報が作成されました。'
    assert_selector 'p', text: 'テストの学習をしました'
    assert_selector 'p', text: '自動テストは素晴らしいです'

    click_on '日報の一覧に戻る'
  end

  test 'should update Report' do
    visit report_url(reports(:taro_report))
    assert_selector 'p', text: '初めての日報'
    assert_selector 'p', text: 'こんにちは！よろしくね！'

    click_on 'この日報を編集'

    fill_in 'タイトル', with: '間違えました'
    fill_in '内容', with: '10回目の日報でした'
    click_on '更新する'

    assert_text '日報が更新されました。'
    assert_selector 'p', text: '間違えました'
    assert_selector 'p', text: '10回目の日報でした'

    click_on '日報の一覧に戻る'
  end

  test 'should destroy Report' do
    report = reports(:taro_report)
    visit reports_url
    assert_selector 'p', text: '初めての日報'

    visit report_url(report)
    click_on 'この日報を削除'
    assert_text '日報が削除されました'

    visit reports_url
    assert has_no_text?('初めての日報')
  end
end
