module Validation
  def validation_input_for_word word
    case
    when (word.nil? or word.empty?) then "Nothing to input"
    when word.include?(':') then "Illegal character"
    else nil
    end
  end 
end 
