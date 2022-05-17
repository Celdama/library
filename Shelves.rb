class Shelves
  attr_reader :shelve_name, :books
  def initialize category
    @containing_category = []
    @books = []
    @shelve_name = category
  end 

  def add_book book
    @books << book
    @containing_category << book.category
  end

  def show_content
    @books.each {|book| p book.get_info}
  end

  def is_in_shelve book_title
    result = @books.find {|book| book.title == book_title}
    puts result&.get_info || 'no matches'
  end 
end
