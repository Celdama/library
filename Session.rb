require './Library.rb'
require './modules/Validation.rb'
require './modules/IrbMessage.rb'
require 'tty-font'
require 'tty-prompt'
require 'pastel'
require 'tty-spinner'
require 'tty-box'


class Session 
  include Validation
  include IrbMessage

  def initialize 
    @library = Library.new
    @prompt = TTY::Prompt.new(active_color: :green)
    @font = TTY::Font.new(:standard)
    @pastel = Pastel.new
    @spinner = TTY::Spinner.new(":spinner Creating new shelve ...", format: :bouncing_ball)
  end


  def start
    @library.empty_shelves_list? ? first_connect : user_choice_if_library_is_not_empty
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
    @prompt.yes?("Do you want to create another shelve ?") == true ? create_shelve : add_new_book
  end

  def search
    if @library.shelves_list?
      puts "you need to create your first shelves, please add a book"
      add_new_book
    else 
      @library.show_shelves_list
    end
  end
  
  def user_choice_if_library_is_not_empty
    # ASK HERE IF USER WANT TO LOOK OR ADD
    answer = @prompt.select('Do you want to :') do |menu|
          menu.choice name: "add a new book in your library", value: 1
          menu.choice name: "check your library", value: 2
    end
    answer == 1 ? add_new_book : check_library 
  end 

  def check_library
    p "you want to search a book"
  end 

  def add_new_book
    puts @pastel.blue.bold("\nAdd a new book ...\n")

    current_shelve = @prompt.select("You need to select your shelve before add a book.\nIf the correct shelve doesn't exist select no shelve option", @library.get_shelves_list_name)

    if current_shelve != "no shelve"
      restart = true
      word = nil
      while restart

        puts @pastel.blue.bold("\nlet's add a new book in your #{current_shelve} shelve\n")

        book_info = @prompt.collect do
          key(:title).ask("Title ?", required: true)
          key(:author).ask("Author ?", required: true)
          key(:year).ask("Year ?", required: true, convert: :int)
        end 
        
        puts book_info

        @library.create_book book_info[:title], book_info[:author], book_info[:year], current_shelve

        # Delete after fin another way to display book
        book_added book_info

        @pastel.green.bold("#{book_info[:title]} by #{book_info[:author]} was added in your Libray.")
        
        answer = @prompt.select('Do you want to :') do |menu|
          menu.choice name: "add another book in #{current_shelve} shelve", value: 1
          menu.choice name: "select another shelve", value: 2
          menu.choice name: "other", value: 3
        end

        if answer == 1
          restart = true
        elsif answer == 2
          restart = false
          add_new_book
        else
          restart = false
          start
        end
      end 
    else 
      create_shelve
    end
  end 
end 

log = Session.new
log.start
