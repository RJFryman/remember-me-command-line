require 'person'
require 'group'

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
      Person.add_menu
    elsif input == "2"
      Group.add_menu
    elsif input == "3"
      Person.edit_menu
    elsif input == "4"
      Group.edit_menu
    elsif input == "5"
      Person.delete_menu
    elsif input == "6"
      Group.delete_menu
    elsif input == "7"
      Group.view_menu
    elsif input == "8"
      puts "Thank you"
      exit
    else puts "'#{input}' is not a valid selection"
      self.selection_process
    end
  end

end
