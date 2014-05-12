require 'person_menu'
require 'group_menu'

class Menu

  def self.options
<<EOS
What do you want to do?
1. Add person
2. Add group
3. Edit person
4. Edit group
5. Delete person
6. Delete group
7. View group contacts
8. Exit
EOS
  end

  def self.selection_process
    puts self.options
    input = gets
    return unless input
    input.chomp!
    if input == "1"
      PersonMenu.add_menu
    elsif input == "2"
      GroupMenu.add_menu
    elsif input == "3"
      PersonMenu.edit_menu
    elsif input == "4"
      GroupMenu.edit_menu
    elsif input == "5"
      PersonMenu.delete_menu
    elsif input == "6"
      GroupMenu.delete_menu
    elsif input == "7"
      GroupMenu.view_menu
    elsif input == "8"
      puts "Thank you"
      exit
    else puts "'#{input}' is not a valid selection"
      self.selection_process
    end
  end

end
