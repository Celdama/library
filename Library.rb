require './Book.rb'
require './Shelves.rb'
require 'pry-byebug'

class Library
  attr_reader :shelves_list
  def initialize 
    @shelves_list = []
  end 

  def create_shelve category
    shelves = Shelves.new category
    @shelves_list << shelves
  end
  
  def add_book_to_shelves book
    current_shelve = shelves_list.find {|shelve| shelve.shelve_name == book.category}
    current_shelve.add_book book
  end

  def create_book title, author, year, category
    new_book = Book.new title, author, year, category
    add_book_to_shelves new_book
  end 

  def get_shelves_list_name
    list_name = []
    @shelves_list.each {|shelve| list_name << shelve.shelve_name}
    list_name
  end

  def get_author_in_shelve
    list_author = []
    @shelves_list.each do |shelve|
      list_author += shelve.get_author_list_in_shelve
    end 
    list_author.uniq
  end

  def show_shelves_content
    @shelves_list.show_content
  end 

  def empty_shelves_list?
    @shelves_list.empty?
  end
end
