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
      sleep(1)
      @spinner.stop("Done") 
      @library.create_shelve category
      puts @pastel.blue.bold("\nyou have successfully added #{category} shelve in your library\n")
    end
    @prompt.yes?("Do you want to create another shelve ?") == true ? create_shelve : add_new_book
  end

  def user_choice_if_library_is_not_empty
    # ASK HERE IF USER WANT TO LOOK OR ADD
    answer = @prompt.select('Do you want to :') do |menu|
          menu.choice name: "add a new book in your library", value: 1
          menu.choice name: "check your library", value: 2
    end
    answer == 1 ? add_new_book : check_library 
  end 

  def search
    if @library.shelves_list?
      puts "you need to create your first shelves, please add a book"
      add_new_book
    else 
      @library.show_shelves_list
    end
  end
  

  def check_library
    @pastel.blue.bold("\nyou want to take a look at your library\n")
    check_answer = @prompt.select('Do you want to check :') do |menu|
      menu.choice name: "your books", value: 1
      menu.choice name: "your shelves", value: 2
    end 

    check_answer == 1 ? check_books : check_shelves
  end 

  def check_books
    @pastel.blue.bold("\nLet's make a check on your books list")
    check_answer = @prompt.select('Do you want to :') do |menu|
      menu.choice name: "check the list of all your books", value: 1
      menu.choice name: "check if one book is already in your library", value: 2
      menu.choice name: "filter your list of books", value: 3
    end 

    if check_answer == 1
      check_all_books
    elsif check_answer == 2
      book_already_in_library
    else
      filter_book
    end 
  end 

  def check_all_books 
    @library.shelves_list.each {|shelve| p shelve.books}
    check_books
  end 

  def book_already_in_library
    puts @pastel.blue.bold("\nLet's check if your book is already in your library!\n")
    book_title = @prompt.ask("What is the title of your book?")
    @library.shelves_list.each {|shelve| shelve.is_in_shelve book_title}
    # TODO : LET USER MAKE CHOICE, 1. GO USER_CHOICE_IF_LIBRARY_NOT_EMPTY OR CHECK_BOOK
    check_books
  end 

  def filter_book
    # BY CATEGORY & BY AUTHOR
    puts @pastel.blue.bold("\nLet's filter your books\n")
    
    filter = @prompt.select('Do you want to filter your books by:') do |menu|
          menu.choice name: "category", value: 1
          menu.choice name: "author", value: 2
    end

    filter == 1 ? filter_book_by_category : filter_book_by_author
  end

  def filter_book_by_category
    filter_category = @prompt.select("Choose your category", @library.get_shelves_list_name)

    filtered_category = @library.shelves_list.find {|shelve| shelve.shelve_name == filter_category}
    # puts filter_catego
    filtered_category.show_content

  end 

  def filter_book_by_author
  end 


  def check_shelves

  end 

  def add_new_book
    puts @pastel.blue.bold("\nAdd a new book ...\n")

    current_shelve = @prompt.select("You need to select your shelve before add a book.\n
        If the correct shelve doesn't exist select no shelve option to create appropriate shelve", @library.get_shelves_list_name << "no shelve")

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

        # book_info[:category] = current_shelve
        
        # puts book_info

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
