# Marylou Lenhart code challenge submission

* I have included the whole rails app in the submission, but
  the location of the files needed are as follows:
  - app/models/book.rb
  - db/migrate/20160121215607_create_books.rb
  And if you'd like to look at the tests for the model, they
  are located:
  - tests/models/book.rb

* All tests are using prepared fixtures. These fixtures are included
  in the submission. And the associated fixtures are here:
  - tests/fixtures/*

* ASSUMPTION made: when calling #search on the Book class,
  with the `:book_format_type_id` option, I assume the format
  of this option is a symbol or string of the format type, as
  it is not reasonable to assume the user knows the Rails-given
  id of the BookFormat.

# The initial challenge:

## Summary:
To see a sample of your Rails code, we’d like you to create a model and
its migration in a fictional application. We’ll provide some general
information about the application, and other related models that exist
within the system (without providing specific code). We’ll specify the
main fields and methods that the model needs to have, and it is up to
you to implement these in the model and migration files.

## Application Background:
The application is an online bookstore. Customers are able to browse and
shop for electronic and physical books, and share their opinions through
book reviews.

## Instructions:
Create the Book model (book.rb) and a migration file to create the model
in the database and implement the fields and methods described in this
document. You may include additional methods in the model beyond the
minimum required if you feel they contribute to a well­rounded and useful
codebase (e.g. overriding #to_s, adding validations, performance
considerations). Write your code for Rails 4.x and Ruby 2.x.
(Optional): Write tests for your book model (use RSpec (preferred),
Test::Unit, or MiniTest).

## Application Model Specifications:
Code for the other models is not supplied. All models have an “id” field
as their primary key.

Publisher: Each book is associated with a single publisher. Assume there
will be ~100 total.

  Key fields:
  `#name(string)`

Author: Each book is written by a single author. Assume there will be
~100,000 total

  Key fields:
  `#first_name(string)`
  `#last_name(string)`

BookFormatType: The formats that a book may be available in. Assume
there will be ~10 tot

  Key fields:
  `#name(string)` such as “Hardcover”, “Softcover” , “Kindle”, “PDF”
  `#physical(boolean)` True means a physical format, false means an
  electronic format

BookFormat: A many­to­many relationship model between Books and their
Formats

  Key fields:
  `#book_id(integer)`
  `#book_format_type_id(integer)`

BookReview: A user’s opinion on a book. Assume there will be ~100 per
book.

  Key fields:
  `#book_id(integer)`
  `#rating(integer)`, in the range 1­5 (5 being the best). Cannot be nil.

## Book Model Specification:
There are three required fields, three required instance methods, and
one required class method.

### Fields of Book:
`title(string)` the title of the book, required
`publisher_id(integer)` the publisher of the book, required
`author_id(integer)` the author of the book, required

### Instance Methods of Book:
book_format_types: Returns a collection of the BookFormatTypes this book
is available in
author_name: The name of the author of this book in “lastname,
firstname” format
average_rating: The average (mean) of all the book reviews for this
book. Rounded to one decimal place.

### Class Method(s) of Book:
`search(query, options)`:

Returns a collection of books that match the query string, subject to
the following rules:

1. If the last name of the author matches the query string exactly (case
insensitive)
2. If the name of the publisher matches the query string exactly (case
insensitive)
3. If any portion of the book’s title matches the query string (case
insensitive)

Search options:
The results should be the union of books that match any of these three
rules. The results should be ordered by average rating, with the highest
rating first. The list should be unique (the same book shouldn't appear
multiple times in the results)

`:title_only`(defaults to false). If true, only return results from rule
 #3 above.

`:book_format_type_id`(defaults to nil). If true, only return books that
are available in a format that matches the supplied type id.

`:book_format_physical`(defaults to nil). If supplied as true or false,
only return books that are available in a format whose “physical” field
matches the supplied argument. This filter is not applied if the argument
is not present or nil.

