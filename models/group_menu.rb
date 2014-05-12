require 'person'
require 'group'
require 'group_membership'
require 'menu'

class GroupMenu
  def self.add_menu
    puts "Name of group you would like to add?"
    group_name = gets
    return unless group_name
    group_name.chomp!
    group = Group.new(group_name)
    if group.save
      puts "#{group_name} has been added."
      Menu.selection_process
    else
      puts group.errors
      Menu.selection_process
    end
  end

  def self.edit_menu
    puts "Name of group you would like to edit?"
    group_name = gets
    return unless group_name
    group_name.chomp!
    group = Group.find_by_name(group_name)
    if group
      puts "1. Enter person into #{group_name}\n2. Remove person from #{group_name}"
      input = gets
      return unless input
      input.chomp!
      if input == "1"
        puts "Who do you want to enter into #{group_name}?"
        person_name = gets
        return unless person_name
        person_name.chomp!
        person = Person.find_by_name(person_name)
        if person
          GroupMembership.create_for(person, group)
          puts "#{person_name} has been added to #{group_name}"
          Menu.selection_process
        else
          puts "#{person_name} is not valid."
          self.edit_menu
        end
      elsif input == "2"
        puts "Who do you want to remove from #{group_name}"
        person_name = gets
        return unless person_name
        person_name.chomp!
        person = Person.find_by_name(person_name)
        if person
          GroupMembership.delete(person, group)
          puts "#{person_name} has been removed from #{group_name}"
          Menu.selection_process
        else
          puts "#{person_name} is not valid."
          self.edit_menu
        end
      else
        puts "'#{input}' is not a valid option."
        Menu.selection_process
      end
    else
      puts "#{group_name} does not exist."
      Menu.selection_process
    end
  end

  def self.delete_menu
    puts "Name of group you would like to delete?"
    group_name = gets
    return unless group_name
    group_name.chomp!
    group = Group.find_by_name(group_name)
    if group
      Group.delete_by_name(group_name)
      puts "#{group_name} has been deleted."
      Menu.selection_process
    else
      puts "#{group_name} does not exist."
      Menu.selection_process
    end
  end

  def self.view_menu
    puts "Name of group you would like to view?"
    group_name = gets
    return unless group_name
    group_name.chomp!
    group = Group.find_by_name(group_name)
    if group
      members = GroupMembership.find_all_in(group)
      puts "Members in #{group_name}"
      members.each do |person|
        puts "NAME : #{person['name']} || Phone Number : #{person['phone_number']} || Email: #{person['email']} || Github: #{person['github']}"
      end
      Menu.selection_process
    else
      puts "#{group_name} does not exits."
      Menu.selection_process
    end
  end
end
