module Validation
  def validation_input_for_word word
    case
    when (word.nil? or word.empty?) then "Nothing to input, try again"
    when word.include?(':') then "Illegal character, try again"
    else nil
    end
  end 
end 
