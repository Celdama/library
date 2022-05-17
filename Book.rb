class Book
  attr_reader :category, :title

  def initialize title, author, year, category
    @title = title
    @author = author
    @year = year
    @category = category
    @label = create_label
  end

  def get_info 
    "#{@title} by #{@author} in #{@year} - #{@category} my label is #{@label}"
  end 

  def create_label
    "#{@category[0]}#{@author[0..2]}"
  end 
end
