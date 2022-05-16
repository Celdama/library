require './Library.rb'
require './modules/Validation.rb'
require './modules/IrbMessage.rb'
require 'tty-font'
require 'tty-prompt'
require 'pastel'
require 'tty-spinner'

class Session 
  include Validation
  include IrbMessage

  def initialize 
    @library = Library.new
    @prompt = TTY::Prompt.new(active_color: :green)
    @font = TTY::Font.new(:standard)
    @pastel = Pastel.new
    @spinner = TTY::Spinner.new("[:spinner] Creating your new shelve ...", format: :pulse_2)
  end


  def start
    @library.empty_shelves_list? ? first_connect : create
  end 

  def first_connect
    puts @pastel.red.bold(@font.write("LIBRARY"))
    puts "Welcome, it's your first connect, your library is empty.\nyou need to create at least one shielve before add a book"
    create_shelve
  end 

  def create_shelve
    puts @pastel.blue.bold("\nCreate a new shelve ...\n")
    category = @prompt.ask("Category name for your shelve :")

    if @library.get_shelves_list_name.include?(category)
      puts @pastel.red.bold("\nShelve #{category} already exist, you can't add two time\n")
    else
      @spinner.auto_spin
      sleep(3)
      @spinner.stop("Done") 
      @library.create_shelve category
      puts @pastel.blue.bold("\nyou have successfully added #{category} shelve in your library\n")
    end
    @prompt.yes?("Do you want to create another shelve ?") == true ? create_shelve : add
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
