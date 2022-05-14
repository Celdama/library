require './Library.rb'
require './modules/Validation.rb'
require './modules/IrbMessage.rb'
require 'tty-font'
require 'tty-prompt'
require 'pastel'

class Session 
  include Validation
  include IrbMessage

  def initialize 
    @library = Library.new
    @prompt = TTY::Prompt.new(active_color: :green)
    @font = TTY::Font.new(:standard)
    @pastel = Pastel.new
  end


  def start
    @library.empty_shelves_list? ? first_connect : create
  end 

  def first_connect
    puts @pastel.red.bold(@font.write("LIBRARY"))
    puts "it's your first connect, your library is empty.\ncreate at least one shielve before add a book"
    puts ""
    choices = [
      {name: "add mutiples shelves", value: 0},
      {name: "add one shelve", value: 1},
    ]
    answer = @prompt.select("select your choice", choices)

    answer == 0 ? create_shelves : create_shelve
  end 

  def create_shelves
    puts "we'll going to create one shelve by one category key word"
    puts "lets get your genre list"
    category_list = []
    list_done = false
    while !list_done
      puts "lets add new shelves"
      puts "whats your category"
      category = gets.chomp
      category_list << category
      puts "category was successfully added"
      puts "do you want create another category"
      puts "0 - non | 1 - oui"
      list_done = gets.chomp == "0"
    end
    category_list.each {|category| @library.create_shelve category}
    puts "you have successfully create #{category_list.length}"
    # TODO: Redirect to create / add action
  end

  def create_shelve
    # TODO : CHECK IF SHELVE NAME IS ALREADY CREATE
    puts ""
    puts @pastel.blue.bold("Create a new shelve ...")
    puts ""

    puts "you want to create juste one shelve"
    puts "give me a category for your shelve"
    category = gets.chomp
    @library.create_shelve category
    p @library
    puts "you have successfully create #{category} shelve"
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
          category: ""
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

        @library.create_book book_info[:title], book_info[:author], book_info[:year], book_info[:category]
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
