class Book < ActiveRecord::Base
  belongs_to :author
  belongs_to :publisher
  has_many :book_reviews
  has_many :book_format_types, through: :book_formats

  def author_name
    "#{author.last_name}, #{author.first_name}"
  end

  def average_rating
    ratings = BookReview.where(book_id: id).map(&:rating)
    ratings.inject{ |sum, rating| sum + rating }.to_f / ratings.size
  end

  def book_format_types
    ids = BookFormat.where(book_id: self.id).map(&:book_format_type_id)
    BookFormatType.where(id: ids)
  end

  def self.search(query, options)
    book = Book.new
    if options[:title_only] == true
      results = book.title_only_search(query)
    else
      results = book.regular_search(query)
    end
    if options[:book_format_type_id]
      results = book.book_format_type_id_search(results, options[:book_format_type_id])
    end
    unless options[:book_format_physical].nil?
      results = book.book_format_physical(results, options[:book_format_physical])
    end
    results.order("book_reviews.rating DESC")
  end

  def title_only_search(query)
    Book.where('lower(title) LIKE ?', "%#{query.downcase}%").includes(:book_reviews).uniq
  end

  def regular_search(query)
    author_ids = Author.where('lower(last_name) = ?', query.downcase).map(&:id)
    publisher_ids = Publisher.where('lower(name) = ?', query.downcase).map(&:id)
    results = 
      Book.where('lower(title) LIKE ? 
                 OR author_id = ? 
                 OR publisher_id = ?', 
                 "%#{query.downcase}%", author_ids, publisher_ids).includes(:book_reviews)
    results.uniq
  end

  def book_format_type_id_search(results, format_type_id)
    book_ids = results.map(&:id)
    id = BookFormatType.where('lower(name) LIKE ?', "%#{format_type_id.downcase}%")
    results_ids = BookFormat.where(book_id: book_ids, book_format_type_id: id).map(&:book_id)
    results.where(id: results_ids).includes(:book_reviews)
  end

  def book_format_physical(results, physical)
    book_ids = results.map(&:id)
    format_ids = BookFormatType.where(physical: physical).map(&:id)
    results_ids = BookFormat.where(book_id: book_ids, book_format_type_id: format_ids).map(&:book_id)
    results.where(id: results_ids).includes(:book_reviews)
  end
end
