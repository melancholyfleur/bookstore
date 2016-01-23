require 'test_helper'

class BookTest < ActiveSupport::TestCase
  test '#author_name' do
    books(:great_beyond).author = authors(:mandrake)
    books(:great_beyond).save
    assert_equal("#{authors(:mandrake).last_name}, #{authors(:mandrake).first_name}", books(:great_beyond).author_name)
  end

  test '#average_rating' do
    assert_equal(3.5, books(:great_beyond).average_rating)
  end

  test '#book_format_types' do
    assert_includes(books(:great_beyond).book_format_types, book_format_types(:pdf))
  end

  test '#book_format_types failed' do
    assert_not_includes(books(:brother_jack).book_format_types, book_format_types(:pdf))
  end

  test 'search for book with title only' do
    options = {}
    options[:title_only] = true
    assert_includes(Book.search('Beyond', options), books(:brother_jack))
  end

  test 'search order of results are by highest rating' do
    options = {}
    options[:title_only] = true
    assert_equal('The Great Beyond', Book.search('Beyond', options).first.title)
  end

  test 'search via author' do
    options = {}
    assert_includes(Book.search('Mandrake', options), books(:great_beyond))
  end

  test 'search for author must be exact' do
    options={}
    assert_not_includes(Book.search('Mand', options), books(:great_beyond))
  end

  test 'search via publisher' do
    options={}
    assert_includes(Book.search('Lord Byron Printings', options), books(:great_beyond))
  end

  test 'search for publisher must be exact' do
    options={}
    assert_not_includes(Book.search('Lord Byron', options), books(:great_beyond))
  end

  test 'search with pdf format type option' do
    options = {}
    options[:book_format_type_id] = :pdf
    assert_includes(Book.search('Beyond', options), books(:great_beyond))
  end

  test 'failed search with pdf format type option' do
    options = {}
    options[:book_format_type_id] = :pdf
    assert_not_includes(Book.search('Beyond', options), books(:brother_jack))
  end

  test 'search for physical book' do
    options = {}
    options[:book_format_physical] = true
    assert_includes(Book.search('Beyond', options), books(:great_beyond))
  end

  test 'failed search for physical book' do
    options = {}
    options[:book_format_physical] = false
    assert_not_includes(Book.search('Beyond', options), books(:brother_jack))
  end
end
