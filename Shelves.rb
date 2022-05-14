class Shelves
  attr_reader :shelve_name
  def initialize genre
    @containing_genre = []
    @books = []
    @shelve_name = genre
  end 

  def add_book book
    @books << book
    @containing_genre << book.genre
  end

  def show_content
    @books.each {|book| p book.get_info}
  end

end
