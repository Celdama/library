require './Book.rb'
require './Shelves.rb'
require 'pry-byebug'

class Library
  attr_reader :shelves_list
  def initialize 
    @shelves_list = []
  end 

  def create_shelve genre
    shelves = Shelves.new genre
    @shelves_list << shelves
  end
  
  def add_book_to_shelves book
    # TODO : FIND THE CORRECT SHELVES WITH GENRE
    puts book
    # @shelves_list.last.add_book book
  end

  def create_book title, author, year, genre
    # ERROR ICI CAR JAI SUPPRIMER LES LIMITES DE SHELVES 
    # IL FAUDRA ICI CHECK SI LE SHELVE EXISTE EN FONCTION DU GENRE 
    # if @shelves_list.length == 0 || 
    #   create_shelves
    # end 
    # binding.pry
    new_book = Book.new title, author, year, genre
    add_book_to_shelves new_book
  end 

  def show_shelves_list
    @shelves_list.each {|shelve| p shelve.shelve_name}
    # show_shelves_content
  end

  def show_shelves_content
    puts "try with first shelves, type 0"
    index = gets.chomp.to_i
    @shelves_list[index].show_content
  end 

  def empty_shelves_list?
    @shelves_list.empty?
  end 

  
  def hello
    "hello world"
  end
end
