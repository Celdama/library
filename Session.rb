# SESSION
require './Library.rb'
require './modules/Validation.rb'

class Session 
  include Validation

  def initialize 
    @library = Library.new
  end


  def start
    puts "tell me what do you want"
    puts "0: add new book | 1: search a book"
    puts "choose a num"
    answer = gets.chomp
    answer == "0" ? add : search
  end 

  def search
    puts "you want to search a book"
  end 

  def add
    puts @library
    restart = true
    word = nil
    while restart
      book_info = {
        title: "",
        author: "",
        year: "",
        genre: ""
      }

      book_info.each do |key, value|
        loop do
          puts "input #{key}"
          word = gets.chomp
          validation_message = validation_input_for_word word
          puts validation_message ? validation_message : "#{key} = #{word}"
          book_info[key] = word
          break if validation_message.nil?
        end
      end
      puts book_info

      @library.create_book book_info[:title], book_info[:author], book_info[:year], book_info[:genre]
      puts "#{word} was added in your Library"
      puts "do you want to add another book"
      puts "yes | no"
      restart = gets.chomp == "yes"
    end

    @library.show_shelves_list
  end 
end 

log = Session.new
log.start
