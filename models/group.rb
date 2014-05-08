class Group
  attr_reader :errors
  attr_reader :id
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def self.add_menu
    puts "Name of group you would like to add?"
  end

  def self.edit_menu
    puts "Name of group you would like to edit?"
  end

  def self.delete_menu
    puts "Name of group you would like to delete?"
  end

  def self.view_menu
    puts "Name of group you would like to view?"
  end

  def self.all
    statement = "Select * from groups;"
    execute_and_instantiate(statement)
  end

  def self.count
    statement = "Select count(*) from groups;"
    result = Environment.database_connection.execute(statement)
    result[0][0]
  end

  def self.create(name)
    group = Group.new(name)
    group.save
    group
  end

  def self.find_by_name(name)
    statement = "Select * from groups where name = ?;"
    execute_and_instantiate(statement, name)[0]
  end

  def self.last
    statement = "Select * from groups order by id DESC limit(1);"
    execute_and_instantiate(statement)[0]
  end

  def save
    if self.valid?
      if self.id
        statement = "Update groups set name = ? where id = ?;"
        Environment.database_connection.execute(statement,[name, self.id])
      else
        statement = "Insert into groups (name) values (?);"
        Environment.database_connection.execute(statement, name)
        @id = Environment.database_connection.execute("SELECT last_insert_rowid();")[0][0]
      end
      true
    else
      false
    end
  end

  def valid?
    @errors = []
    if !name.match /[a-zA-Z]/
      @errors << "'#{self.name}' is not a valid group name, as it does not include any letters."
    end
    if Group.find_by_name(self.name)
      @errors << "#{self.name} already exists."
    end
    @errors.empty?
  end

  private

  def self.execute_and_instantiate(statement, bind_vars = [])
    rows = Environment.database_connection.execute(statement, bind_vars)
    results = []
    rows.each do |row|
      group = Group.new(row["name"])
      group.instance_variable_set(:@id, row["id"])
      results << group
    end
    results
  end
end
