class GroupMembership
  def self.create_for(person, group)
    statement = "Insert into group_memberships (person_id, group_id) values (?, ?);"
    Environment.database_connection.execute(statement, [person.id, group.id])
  end
  def self.delete(person, group)
    statement = "DELETE FROM group_memberships where person_id =? and group_id =?;"
    Environment.database_connection.execute(statement, [person.id, group.id])
  end
  def self.find_all_in(group)
    statement = "Select people.name, people.phone_number, people.email, people.github from group_memberships JOIN people ON (person_id=people.id)where group_id = ?;"
    Environment.database_connection.execute(statement, group.id)
  end
  def self.find_all_for(person)
    statement = "Select groups.name from group_memberships JOIN groups ON (group_id=groups.id)where person_id = ?;"
    Environment.database_connection.execute(statement, person.id)
  end
  def self.count
    statement = "Select count(*) from group_memberships;"
    Environment.database_connection.execute(statement)[0][0]
  end
end
