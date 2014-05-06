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
      puts "Name of person you would like to add?"
    elsif input == "2"
      puts "Name of group you would like to add?"
    elsif input == "3"
      puts "Name of person you would like to edit?"
    elsif input == "4"
      puts "Name of group you would like to edit?"
    elsif input == "5"
      puts "Name of person you would like to delete?"
    elsif input == "6"
      puts "Name of group you would like to delete?"
    elsif input == "7"
      puts "Name of group you would like to view?"
    elsif input == "8"
      puts "Thank you"
      exit
    else puts "'#{input}' is not a valid selection"
      self.selection_process
    end
  end

end
