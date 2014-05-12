class Person < ActiveRecord::Base
  attr_reader :errors, :id
  attr_accessor :name, :phone_number, :email, :github

  def initialize(name, phone_number, email, github)
    @name = name
    @phone_number = phone_number
    @email = email
    @github = github
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

  def self.create(name, phone_number, email, github)
    person = Person.new(name, phone_number, email, github)
    person.save
    person
  end

  def self.delete_by_name(name)
    statement = "DELETE FROM people where name =?;"
    execute_and_instantiate(statement, name)[0]
  end

  def self.find_by_name(name)
    statement = "Select * from people where name = ?;"
    execute_and_instantiate(statement, name)[0]
  end

  def self.last
    statement = "Select * from people order by id DESC limit(1);"
    execute_and_instantiate(statement)[0]
  end

  def update
    if self.id
      statement = "Update people set name = ?, phone_number = ?, email = ?, github =? where id = ?;"
      Environment.database_connection.execute(statement,[self.name, self.phone_number, self.email, self.github, self.id])[0]
    end
  end

  def save
    if self.valid?
      if self.id
        statement = "Update people set name = ?, phone_number = ?, email = ?, github =? where id = ?;"
        Environment.database_connection.execute(statement,[self.name, self.phone_number, self.email, self.github, self.id])[0]
      else
        statement = "Insert into people (name, phone_number, email, github) values (?, ?, ?, ?);"
        Environment.database_connection.execute(statement, [name, phone_number, email, github])
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
      person = Person.new(row["name"], row["phone_number"], row["email"], row["github"])
      person.instance_variable_set(:@id, row["id"])
      results << person
    end
    results
  end
end
