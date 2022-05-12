require './Book.rb'
require './Shelves.rb'

class Library

  def initialize 
    @shelves_list = []
  end 

  def create_shelves
    shelves = Shelves.new
    @shelves_list << shelves
  end
  
  def add_book_to_shelves book
    @shelves_list.last.add_book book
  end 

  def create_book title, author, year, genre
    if @shelves_list.length == 0 || @shelves_list.last.is_full?
      create_shelves
    end 
    new_book = Book.new title, author, year, genre
    add_book_to_shelves new_book
  end 

  def show_shelves_list
    p @shelves_list.length
    @shelves_list[0].show_content
    print "-----"
    @shelves_list[1].show_content
  end

  
  def hello
    "hello world"
  end
end
