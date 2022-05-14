# require "tty-prompt"
# require "tty-font"
# require "tty-table"



# https://github.com/piotrmurach/tty-prompt

# prompt = TTY::Prompt.new(active_color: :cyan)
# prompt = TTY::Prompt.new


# prompt.ask("What is your name?", default: "test default")
# # confirm input
# prompt.yes?("Do you like Ruby?")
# # password
# prompt.mask("What is your secret?")

# list de choix
# prompt.select("Choose your destiny?", %w(Scorpion Kano Jax))


# multiple choice
# choices = %w(vodka beer wine whisky bourbon)
# prompt.multi_select("Select drinks?", choices)


# enumchoices = %w(emacs nano vim)
# prompt.enum_select("Select an editor?", choices) #CE QUIL ME FAUT POUR CHOISIR UNE SHELVE


# collect more answord => CE QUIL ME FAUT POUR AJOUTER UN LIVRE 
# result = prompt.collect do
#   key(:name).ask("Name?")

#   key(:age).ask("Age?", convert: :int)

#   key(:address) do
#     key(:street).ask("Street?", required: true)
#     key(:city).ask("City?")
#     # key(:zip).ask("Zip?", validate: /\A\d{3}\Z/)
#   end
# end


# To protect response
# prompt.ask("What is your name?") do |q|
#   q.required true
#   q.validate /\A\w+\Z/
#   q.modify   :capitalize
# end

# placeholder
# prompt.ask("What is your name?", value: "Piotr")

# ne pas display la response
# prompt.ask("password:", echo: false)

# Multiline
# prompt.multiline("Description?")
# prompt.multiline("Description?", default: "A super sweet prompt.")


# YES OR NO => UTILE POUR MON PROJET
# prompt.yes?("Do you like Ruby?")
# customise YES OR NO
# prompt.yes?("Are you a human?") do |q|
#   q.suffix "Yup/nope"
# end


#CHOICE 
# choices = {small: 1, medium: 2, large: 3}
# prompt.select("What size?", choices)

# with option
# choices = [
#   {name: "small", value: 1},
#   {name: "medium", value: 2, disabled: "(out of stock)"},
#   {name: "large", value: 3}
# ]
# prompt.select("What size?", choices)

# CHANGE LA PAGINATION DES CHOIX
# letters = ("A".."Z").to_a
# prompt.select("Choose your letter?", letters, per_page: 4)
# =>
# Which letter? (Use ↑/↓ and ←/→ arrow keys, press Enter to select)
# ‣ A
#   B
#   C
#   D

# FILTER LIST !!!!!!!!!!!
# warriors = %w(Scorpion Kano Jax Kitana Raiden)
# prompt.select("Choose your destiny?", warriors, filter: true)


# Say 

# prompt.ok("thats good bro") # UTILE !!!!!

# prompt.select("What size?", %w(Large Medium Small), active_color: :red)

########
# FONT #
########


# https://github.com/piotrmurach/tty-font

# font = TTY::Font.new(:doom)
# pastel = Pastel.new
# puts font.write("DOOM")
# puts pastel.yellow(font.write("DOOM"))


# font = TTY::Font.new(:standard)
# pastel = Pastel.new

# puts pastel.yellow(font.write("Library"))


#########
# TABLE #
########

# http://github.com/piotrmurach/tty-table

# table = TTY::Table.new(["header1","header2eeeee"], [["a1", "a2"], ["b1", "b2"]])
# renderer = TTY::Table::Renderer::Unicode.new(table)

# puts table.render(:unicode)

# table.each { |row| p row }  
