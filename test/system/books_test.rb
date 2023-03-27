# frozen_string_literal: true

require 'application_system_test_case'

class BooksTest < ApplicationSystemTestCase
  setup do
    @raise_server_errors = Capybara.raise_server_errors
    login
  end

  teardown do
    # 元の値に戻す
    Capybara.raise_server_errors = @raise_server_errors
  end

  test 'visiting the index' do
    visit books_url
    assert_selector 'h1', text: '本の一覧'
  end

  test 'should create book' do
    visit books_url
    click_on '本の新規作成'

    fill_in 'タイトル', with: 'オブジェクト指向でなぜつくるのか'
    fill_in 'メモ', with: 'オブジェクト指向と開発技術の本質をズバリ解説'
    click_on '登録する'

    assert_text '本が作成されました。'
    assert_selector 'p', text: 'オブジェクト指向でなぜつくるのか'
    assert_selector 'p', text: 'オブジェクト指向と開発技術の本質をズバリ解説'
    click_on '本の一覧に戻る'
  end

  test 'should update Book' do
    visit book_url(books(:testing_book))
    assert_selector 'p', text: 'テストに関する本'
    assert_selector 'p', text: 'ロボットの絵が描かれている'
    click_on 'この本を編集'

    fill_in 'タイトル', with: '初めての自動テスト'
    fill_in 'メモ', with: 'Webシステムのための自動テスト基礎'
    click_on '更新'

    assert_text '本が更新されました。'
    assert_selector 'p', text: '初めての自動テスト'
    assert_selector 'p', text: 'Webシステムのための自動テスト基礎'

    click_on '本の一覧に戻る'
  end

  test 'should destroy Book' do
    book = books(:erd_book)
    visit book_url(book)
    click_on 'この本を削除', match: :first

    assert_text '本が削除されました。'

    Capybara.raise_server_errors = false

    visit book_url(book)
    assert_text 'ActiveRecord::RecordNotFound'
  end
end
