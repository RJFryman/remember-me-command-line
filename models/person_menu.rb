require 'person'
require 'menu'
require 'group_membership'

class PersonMenu
  def self.add_menu
    puts "Name of person you would like to add?"
    name = gets
    return unless name
    name.chomp!
    check = Person.find_by_name(name)
    if check
      puts "#{name} already exists."
      self.add_menu
    else
      puts "What is the phone number for #{name}?"
      number = gets
      return unless number
      number.chomp!
      puts "What is the email for #{name}?"
      email = gets
      return unless email
      email.chomp!
      puts "What is the Github account for #{name}"
      github = gets
      return unless github
      github.chomp!
      person = Person.new(name, number, email, github)
      if person.save
        puts "#{name} has been added."
        Menu.selection_process
      else
        puts person.errors
        Menu.selection_process
      end
    end
  end

  def self.edit_menu
    puts "Name of person you would like to edit?"
    person_name = gets
    return unless person_name
    person_name.chomp!
    person = Person.find_by_name(person_name)
    if person
      puts "What do you want to edit about #{person_name}"
      puts "1. #{person_name}'s phone number\n2. #{person_name}'s email\n3. #{person_name}'s github"
      input = gets
      return unless input
      input.chomp!
      if input == "1"
        puts "What is the new phone number?"
        person.phone_number = gets
        return unless person.phone_number
        person.phone_number.chomp!
        person.update
        puts "#{person.name} has been edited."
        Menu.selection_process
      elsif input == "2"
        puts "What is the new email?"
        person.email = gets
        return unless person.email
        person.email.chomp!
        person.update
        puts "#{person.name} has been edited."
        Menu.selection_process
      elsif input == "3"
        puts "What is the new Github?"
        person.github = gets
        return unless person.github
        person.github.chomp!
        person.update
        puts "#{person.name} has been edited."
        Menu.selection_process
      else
        puts "#{input} is not a valid choice."
        self.edit_menu
      end
    else
      puts "#{person_name} does not exist."
      Menu.selection_process
    end
  end

  def self.delete_menu
    puts "Name of person you would like to delete?"
    person_name = gets
    return unless person_name
    person_name.chomp!
    person = Person.find_by_name(person_name)
    if person
      Person.delete_by_name(person_name)
      puts "#{person_name} has been deleted."
      Menu.selection_process
    else
      puts "#{person_name} does not exist."
      Menu.selection_process
    end
  end
end
