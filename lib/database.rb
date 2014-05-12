require "sqlite3"

class Database < SQLite3::Database
  def initialize(database)
    super(database)
    self.results_as_hash = true
  end

  def self.connection(environment)
    @connection ||= Database.new("db/remember_me_#{environment}.sqlite3")
  end

  def create_tables
     self.execute("CREATE TABLE people (id INTEGER PRIMARY KEY AUTOINCREMENT, name varchar(50), phone_number varchar(50), email varchar(50), github varchar(50))")
     self.execute("CREATE TABLE groups (id INTEGER PRIMARY KEY AUTOINCREMENT, name varchar(50))")
     self.execute("CREATE TABLE group_memberships (id INTEGER PRIMARY KEY AUTOINCREMENT, person_id INTERGER, group_id INTERGER)")
  end

  def execute(statement, bind_vars = [])
    Environment.logger.info("Executing: #{statement} with: #{bind_vars}")
    super(statement, bind_vars)
  end
end
