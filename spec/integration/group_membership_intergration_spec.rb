require_relative '../spec_helper'

describe "Group Memberships working" do
  before do
    person = Person.new("Robert", "123-456-7890", "robert.nomail.com", "@rjfryman")
    group = Group.new("NSS")
    person.save
    group.save
  end
  context "adding a group membership" do
    let(:output){ run_rm_with_input("4", "NSS","1","Robert") }
    it "should print a confirmation message" do
      output.should include ("Robert has been added to NSS.")
    end
    it "should insert a group membership" do
      output
      GroupMembership.count.should == 1
    end
  end
  context "deleting a group membership" do
    before do
      run_rm_with_input("4", "NSS","1","Robert")
    end
    let(:output){ run_rm_with_input("4", "NSS","2","Robert") }
    it "should print a confirmation message" do
      output.should include("Robert has been removed from NSS.")
    end
    it "should lower the group membershio" do
      output
      GroupMembership.count.should == 0
    end
  end
  context "viewing group memberships" do
    before do
      run_rm_with_input("4", "NSS","1","Robert")
    end
    let(:output){ run_rm_with_input("7", "NSS") }
    it "should print the members of NSS" do
      output.should include ("Name : Robert || Phone Number : 123-456-7890 || Email: robert.nomail.com || Github: @rjfryman")
    end
  end
end
