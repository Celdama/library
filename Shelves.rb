class Shelves
  def initialize remaining_spot = 20
    @containing_section = []
    @books = []
    @remaining_spot = remaining_spot
  end 

  def add_book book
    book
    @books << book
    @remaining_spot -= 1
  end

  def show_content
    @books.each {|book| p book.get_info}
  end

  def is_full?
    @remaining_spot == 0
  end 

end
