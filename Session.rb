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
    puts "Welcome, it's your first connect, your online library is empty.\nyou need to create at least one shielve before add a book"
    create_shelve
  end 

  def user_choice_if_library_is_not_empty
    puts @pastel.blue.bold("\nyour personal library...\n")

    user_choice = @prompt.select('Do you want to :') do |menu|
          menu.choice name: "add a new book in your library", value: 1
          menu.choice name: "create shelve", value: 2
          menu.choice name: "check your library", value: 3
          menu.choice name: "exit", value: 4
    end

    case user_choice
    when 1
      add_new_book
    when 2 
      create_shelve
    when 3
      consult_library_actions
    else 
      "clear"
    end
    
  end 

  def create_shelve
    puts @pastel.blue.bold("\nCreate a new shelve ...\n")
    shelve_category = @prompt.ask("Category name for your shelve :")

    if @library.get_shelves_list_name.include?(shelve_category)
      puts @pastel.red.bold("\nShelve #{shelve_category} already exist, you can't add two time\n")
    else
      @spinner.auto_spin
      sleep(2)
      @spinner.stop("Done") 
      @library.create_shelve shelve_category.strip
      puts @pastel.blue.bold("\nyou have successfully added #{shelve_category} shelve in your library\n")
    end
    @prompt.yes?("Do you want to create another shelve ?") == true ? create_shelve : user_choice_if_library_is_not_empty
  end

  def search
    if @library.shelves_list?
      puts "you need to create your first shelves, please add a book"
      add_new_book
    else 
      @library.show_shelves_list
    end
  end
  

  def consult_library_actions
    @pastel.blue.bold("\nyou want to take a look at your library\n")
    library_action = @prompt.select('Do you want to check :') do |menu|
      menu.choice name: "your books", value: 1
      menu.choice name: "your shelves", value: 2
      menu.choice name: "back", value: 3
      menu.choice name: "exit", value: 4
    end 

    case library_action
    when 1
      consult_books
    when 2
      consult_shelves
    when 3
      user_choice_if_library_is_not_empty
    else 
      "clear"
    end
  end 

  def consult_books
    @pastel.blue.bold("\nLet's make a check on your books list")
    books_action = @prompt.select('Do you want to :') do |menu|
      menu.choice name: "check the list of all your books", value: 1
      menu.choice name: "check if one book is already in your library", value: 2
      menu.choice name: "filter your list of books", value: 3
      menu.choice name: "back", value: 4
      menu.choice name: "exit", value: 5
    end 

    case books_action
    when 1
      get_all_books
    when 2
      is_book_already_in_library
    when 3
      use_filter_book
    when 4
      consult_library_actions
    else
      "clear"
    end
  end 

  
  def consult_shelves
    puts "here check shelves"
    @pastel.blue.bold("\nLet's make a check on your shelves list")
    shelves_action = @prompt.select('Do you want to :') do |menu|
      menu.choice name: "check the content by shelve's name", value: 1
      menu.choice name: "check the number of shelves in your library", value: 2
    end 

    # rename get ? 
    shelves_action == 1 ? get_shelve_content_by_name : get_shelves_number

  end

  def get_shelve_content_by_name
    shelve_name_choice = @prompt.select("Choose your category", @library.get_shelves_list_name)
    current_shelve = @library.shelves_list.find {|shelve| shelve.shelve_name == shelve_name_choice}
    current_shelve.show_content
  end

  def get_shelves_number
    puts @pastel.blue.bold("\nyou have #{@library.shelves_list.length} shelves in your library !\n")
  end

  def get_all_books 
    @library.shelves_list.each {|shelve| p shelve.books}
    consult_books
  end 

  def is_book_already_in_library
    puts @pastel.blue.bold("\nLet's check if your book is already in your library!\n")
    book_title = @prompt.ask("What is the title of your book?")
    @library.shelves_list.each {|shelve| shelve.is_in_shelve book_title}
    # TODO : LET USER MAKE CHOICE, 1. GO USER_CHOICE_IF_LIBRARY_NOT_EMPTY OR CHECK_BOOK
    consult_books
  end 

  def use_filter_book
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
    filtered_category.show_content
    consult_books
  end 

  def filter_book_by_author
    filtered_author = @prompt.select("Choose your author", @library.get_author_in_shelve)

    @library.shelves_list.each do |shelve|
      books_by_filtered_author = shelve.get_book_by_author filtered_author
      p books_by_filtered_author
      consult_books
    end 

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
          key(:title).ask("Title ?", required: true).strip
          key(:author).ask("Author ?", required: true).strip
          key(:year).ask("Year ?", required: true, convert: :int)
        end 

        @library.create_book book_info[:title], book_info[:author], book_info[:year], current_shelve

        # Delete after find another way to display book
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

      create_shelve
    end
  end 
end 

log = Session.new
log.start
