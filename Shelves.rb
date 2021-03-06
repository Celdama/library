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

  def get_author_list_in_shelve
    author_list = []
    @books.each do |book|
      if !author_list.include?(book.author)
        author_list << book.author
      end 
    end
    author_list
  end 
end
