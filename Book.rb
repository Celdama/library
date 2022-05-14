class Book
  attr_reader :genre

  def initialize title, author, year, genre
    @title = title
    @author = author
    @year = year
    @genre = genre
    @label = create_label
  end

  def get_info 
    "#{@title} by #{@author} in #{@year} - #{@genre} my label is #{@label}"
  end 

  def create_label
    "#{@genre[0]}#{@author[0..2]}"
  end 
end
