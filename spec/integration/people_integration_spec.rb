require_relative '../spec_helper'

describe "Person" do
  before do
    person = Person.new("Robert", "123-456-7890", "robert@nomail.com", "@robert")
    person.save
  end
  context "adding a unique person" do
    let(:output){ run_rm_with_input("1", "amber", "098-765-4321", "amber@nomail.com", "@amber") }
    it "should pront a confirmation message" do
      output.should include("amber has been added.")
    end
    it "should insert a new person" do
      output
      Person.count.should == 2
    end
    it "should thave the information added to the database" do
      output
      Person.last.name.should == "amber"
    end
    it "should have the same phone number" do
      output
      Person.last.phone_number.should == "098-765-4321"
    end
    it "should have the same email" do
      output
      Person.last.email.should == "amber@nomail.com"
    end
    it "should have the same github" do
      output
      Person.last.github.should == "@amber"
    end
  end
  context "adding a diplcate person" do
    let(:output){ run_rm_with_input("1", "Robert") }
    it "should print an error message" do
      output.should include("Robert already exists.")
    end
    it "should ask them to try again" do
      menu_text = "Name of person you would like to add?"
      output.should include_in_order(menu_text, "already exists", menu_text)
    end
    it "shouldnt save the diplciate person" do
      output
      Person.count.should == 1
    end
    context "let you try again" do
      let(:output){ run_rm_with_input("1","Robert", "amber", "098-765-4321", "amber@nomail.com", "@amber") }
      it "should save a unique person" do
        output
        Person.last.name.should == "amber"
      end
      it "should print a succes message at the end" do
        output.should include("amber has been added")
      end
    end
  end
  context "editing a person's name already in the database" do
    let(:output){ run_rm_with_input("3","Robert","1","555-123-9876")}
    it "should change the phone number of the person" do
      output
      Person.last.phone_number.should == "555-123-9876"
    end
    it "should contain a confirmation message" do
      output.should include("Robert has been edited.")
    end
  end
  context "editing a persons email should do that" do
    let(:output){ run_rm_with_input("3","Robert","2","bob@nomail.com")}
    it "should change the email in the database" do
      output
      Person.last.email.should == "bob@nomail.com"
    end
    it "should contain a confirmation message" do
      output.should include("Robert has been edited.")
    end
  end
  context "editing a person github should do stuff" do
    let(:output){ run_rm_with_input("3","Robert","3","@bob")}
    it "should change the github" do
      output
      Person.last.github.should == "@bob"
    end
    it "should contain a confirmation message" do
      output.should include("Robert has been edited.")
    end
  end
  context "deleteing a person" do
    let(:output){ run_rm_with_input("5", "Robert")}
    it "should delete the person with message" do
      output.should include("Robert has been deleted.")
    end
    it "should remove from the database" do
      output
      Person.count.should == 0
    end
  end
  context "deleting a person that does not exist" do
    let(:output){ run_rm_with_input("5", "bob")}
    it "should give you a message" do
      output.should include("bob does not exist.")
    end
    it "should remain the number of people in the database" do
      output
      Person.count.should == 1
    end
  end
end
