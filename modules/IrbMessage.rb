module IrbMessage
  def book_added book
    puts "        ----------------------
      |         #{book[:title]}          |
      |         by #{book[:author]}       |
      |        in #{book[:year]}        |
        ----------------------
      "
  end 
end 
