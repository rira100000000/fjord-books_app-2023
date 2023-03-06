# frozen_string_literal: true

require 'test_helper'

class BooksControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @book = books(:one)
  end

  test 'should get index' do
    sign_in users(:user1)
    get books_url
    assert_response :success
  end

  test 'redirects to sign in page when not logged in' do
    get books_url
    assert_response :redirect
  end

  test 'should get new' do
    sign_in users(:user1)
    get new_book_url
    assert_response :success
  end

  test 'should create book' do
    sign_in users(:user1)
    assert_difference('Book.count') do
      post books_url, params: { book: { memo: @book.memo, title: @book.title } }
    end

    assert_redirected_to book_url(Book.last)
  end

  test 'should show book' do
    sign_in users(:user1)
    get book_url(@book)
    assert_response :success
  end

  test 'should get edit' do
    sign_in users(:user1)
    get edit_book_url(@book)
    assert_response :success
  end

  test 'should update book' do
    sign_in users(:user1)
    patch book_url(@book), params: { book: { memo: @book.memo, title: @book.title } }
    assert_redirected_to book_url(@book)
  end

  test 'should destroy book' do
    sign_in users(:user1)
    assert_difference('Book.count', -1) do
      delete book_url(@book)
    end

    assert_redirected_to books_url
  end
end
