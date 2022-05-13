require './Library.rb'
require './modules/Validation.rb'
require './modules/IrbMessage.rb'

class Session 
  include Validation
  include IrbMessage

  def initialize 
    @library = Library.new
  end


  def start
    print "tell me what do you want\n0: add new book | 1: search a book | 2: exit\nEnter your choice:"
    answer = gets.chomp
    case answer
    when "0" then add
    when "1" then search
    else puts "bye"
    end
  end 

  def search
    puts "you want to search a book"
  end 

  def add
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

      book_added book_info[:title], book_info[:author], book_info[:year]


      puts "#{word} was added in your Library\ndo you want to add another book\nyes | no"
      restart = gets.chomp == "yes"
    end

    @library.show_shelves_list
  end 
end 

log = Session.new
log.start
