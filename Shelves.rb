class Shelves
  attr_reader :shelve_name
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

end
