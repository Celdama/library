# accueillir un nombre limité de books 
class Shelves
  def initialize remaining = 20
    @containing_section = []
    @books = []
    @remaining = remaining
  end 

  def add_book book
    book
    @books << book
    @remaining -= 1
  end

  def show_content
    @books.each {|book| p book.get_info}
  end

  def is_full?
    @remaining == 0
  end 

end
