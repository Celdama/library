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
    @library.empty_shelves_list? ? first_connect : create
    # print "tell me what do you want\n0: add new book | 1: search a book | 2: exit\nEnter your choice:"
    # answer = gets.chomp
    # case answer
    # when "0" then add
    # when "1" then search
    # else puts "bye"
    # end
  end 

  def first_connect
    puts "it's your first connect, your library is empty."
    puts "you need to create at least one shielve for be able to add a book"
    puts "so let's go"
    print "you want to enter a list of genre and create one shelves by book enter 0\nyou want to create juste one shelve enter 1\n0: add multiple shelves  | 1: add just one shelve | 2: exit\nEnter your choice:"
    answer = gets.chomp
    case answer
    when "0" then create_shelves
    when "1" then create_shelve
    end 
  end 

  def create_shelves
    puts "we'll going to create one shelve by one genre key word"
    puts "lets get your genre list"
    genre_list = []
    list_done = false
    while !list_done
      puts "lets add new shelves"
      puts "whats your genre"
      genre = gets.chomp
      genre_list << genre
      puts "genre was successfully added"
      puts "do you want create another genre"
      puts "0 - non | 1 - oui"
      list_done = gets.chomp == "0"
    end
    genre_list.each {|genre| @library.create_shelve genre}
    puts "you have successfully create #{genre_list.length}"
    # TODO: Redirect to create / add action
  end

  def create_shelve
    # TODO : CHECK IF SHELVE NAME IS ALREADY CREATE
    puts "you want to create juste one shelve"
    puts "give me a genre to your shelve"
    genre = gets.chomp
    @library.create_shelve genre
    p @library
    puts "you have successfully create #{genre} shelve"
    puts "do you want create a new shel or not"
    puts "0 - non | 1 - oui"
    gets.chomp == "0" ? add : create_shelve
  end

  def search
    if @library.shelves_list?
      puts "you need to create your first shelves, please add a book"
      add
    else 
      @library.show_shelves_list
    end
  end 

  def add
    p "============="
    @library.show_shelves_list
    p "============="
    p "check in this list, if the shelve for your book's genre is already here press 1 or press 0 cause you need to add a shelve for this genre before"
    answer = gets.chomp

    if answer == "1"
      # case answer
      restart = true
      word = nil
      while restart
        book_info = {
          title: "",
          author: "",
          year: "",
          genre: ""
        }

        # TODO : JE SAIS PAS TROP OU. GUIDER L4UTILISATEUR, QUAND ON LUI MONTRE LA LISTE DES SHELS
        # LE FAIRE CHOISIR DANS QUEL SHELVE IL SOUHAITE AJOUTER SON LIVRE, ET NE PLUS LUI LAISSER
        # LA POSSIBILIT2 DAJOUTER UN GENRE

        puts "let's add a new book"

        book_info.each do |key, value|
          loop do
            puts "input #{key}"
            word = gets.chomp
            validation_message = validation_input_for_word word
            puts validation_message ? validation_message : "#{key} = #{word}"
            book_info[key] = word
            if validation_message.nil?
              break
            end 
          end 
        end
        puts book_info

        @library.create_book book_info[:title], book_info[:author], book_info[:year], book_info[:genre]
        book_added book_info
        
        puts "#{word} was added in your Library\ndo you want to add another book\nyes | no"
        restart = gets.chomp == "yes"
      end 
    else 
      create_shelve
    end 

    @library.show_shelves_list
    start
  end 
end 

log = Session.new
log.start
