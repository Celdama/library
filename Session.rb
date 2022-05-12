# SESSION
require './Library.rb'

class Session 
  def initialize 
    @library = Library.new
  end


  def start
    puts "tell me what do you want"
    puts "0: add new book | 1: search a book"
    puts "choose a num"
    answer = gets.chomp
    answer == "0" ? add : search


    
    # puts "title ?"
    # title = gets.chomp
    # puts "author?"
    # author = gets.chomp
    # puts "year?"
    # year = gets.chomp
    # puts "genre?"
    # genre = gets.chomp


    # library = Library.new
    # # library.create_book title, author, year, genre
    # (0..4).each do |i|
    #   library.create_book "foo#{i}", "foo", 234, "hoor#{i}"
    # end 

    # library.show_shelves_list
    
  end 

  def search
    puts "you want to search a book"
  end 

  def add
    puts @library
    restart = true
    while restart
      puts "you want to add a book"
      puts "Title ?"
      title = gets.chomp
      puts "author?"
      author = gets.chomp
      puts "year?"
      year = gets.chomp
      puts "genre?"
      genre = gets.chomp

      @library.create_book title, author, year, genre
      puts "#{title} was added in your Library"

      
      puts "do you want to add another book"
      puts "yes | no"
      restart = gets.chomp == "yes"
    end

    @library.show_shelves_list
  end 
end 

log = Session.new
log.start
