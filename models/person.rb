class Person
  attr_reader :errors, :id
  attr_accessor :name, :phone_number, :email, :github

  def initialize(name)
    @name = name
  end

  def self.add_menu
    puts "Name of person you would like to add?"
  end

  def self.edit_menu
    puts "Name of person you would like to edit?"
  end

  def self.delete_menu
    puts "Name of person you would like to delete?"
  end

  def self.all
    statement = "Select * from people;"
    execute_and_instantiate(statement)
  end

  def self.count
    statement = "Select count(*) from people;"
    result = Environment.database_connection.execute(statement)
    result[0][0]
  end

  def self.create(name)
    person = Person.new(name)
    person.save
    person
  end

  def self.find_by_name(name)
    statement = "Select * from people where name = ?;"
    execute_and_instantiate(statement, name)[0]
  end

  def self.last
    statement = "Select * from people order by id DESC limit(1);"
    execute_and_instantiate(statement)[0]
  end

  def save
    if self.valid?
      if self.id
        statement = "Update people set name = ? where id = ?;"
        Environment.database_connection.execute(statement,[name, self.id])
      else
        statement = "Insert into people (name) values (?);"
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
      @errors << "'#{self.name}' is not a valid person name, as it does not include any letters."
    end
    if Person.find_by_name(self.name)
      @errors << "#{self.name} already exists."
    end
    @errors.empty?
  end

  private

  def self.execute_and_instantiate(statement, bind_vars = [])
    rows = Environment.database_connection.execute(statement, bind_vars)
    results = []
    rows.each do |row|
      person = Person.new(row["name"])
      person.instance_variable_set(:@id, row["id"])
      results << person
    end
    results
  end
end
