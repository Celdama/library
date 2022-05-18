class Shelves
  attr_reader :shelve_name, :books, :containing_author
  def initialize category
    @containing_category = []
    @containing_author = []
    @books = []
    @shelve_name = category
  end 

  def add_book book
    @books << book
    @containing_category << book.category
    if !@containing_author.include?(book.author)
      @containing_author << book.author
    end 
  end

  def show_content
    @books.each {|book| p book.get_info}
  end

  def is_in_shelve book_title
    result = @books.find {|book| book.title == book_title}
    puts result&.get_info || 'no matches'
  end
  
  def get_book_by_author author
    @books.select {|book| book.author == author}
  end 
end
