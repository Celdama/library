# SESSION
require './Library.rb'

class Session 
  def start
    # puts "title ?"
    # title = gets.chomp
    # puts "author?"
    # author = gets.chomp
    # puts "year?"
    # year = gets.chomp
    # puts "genre?"
    # genre = gets.chomp
    library = Library.new
    # library.create_book title, author, year, genre
    (0..30).each do |i|
      library.create_book "foo#{i}", "foo", 234, "hoor#{i}"
    end 

     library.show_shelves_list
    
  end 
end 

log = Session.new
log.start
