require_relative '../spec_helper'

describe "Group" do
  before do
    group = Group.new("NSS")
    group.save
  end
  context "adding a unique group" do
    let(:shell_output){ run_rm_with_input("2", "soggies") }
    it "should print a confirmation message" do
      shell_output.should include("soggies has been added.")
    end
    it "should insert a new group" do
      shell_output
      Group.count.should == 2
    end
    it "should use the name we entered" do
      shell_output
      Group.last.name.should == "soggies"
    end
  end
  context "adding a duplciate group" do
    let(:shell_output){ run_rm_with_input("2", "NSS") }
    it "should print an error message" do
      shell_output.should include("NSS already exists.")
    end
    it "shouldn't save the duplicate" do
      shell_output
      Group.count.should == 1
    end
    it "should ask them to try again" do
      menu_text = "Name of group you would like to add?"
      shell_output.should include_in_order(menu_text, "already exists.", menu_text)
    end
    context "and trying again" do
      let(:shell_output){ run_rm_with_input("2", "NSS", "soggies") }
      it "should save a uniqe item" do
        shell_output
        Group.last.name.should == "soggies"
      end
      it "should print a succes message" do
      shell_output.should include("soggies has been added.")
      end
    end
  end
  context "entering an invalid looking group name" do
    context "with SQL injection" do
      let(:input){ "super_friends'), ('425" }
      let(:shell_output){ run_rm_with_input("2", input) }
      it "should create the group without evaluating the SQL" do
        shell_output
        Group.last.name.should == input
      end
      it "should create 1 extra group" do
        shell_output
        Group.count.should == 2
      end
      it "should print a succss message at the end" do
        shell_output.should include("#{input} has been added")
      end
    end
    context "without alpabet charaters" do
      let(:shell_output){ run_rm_with_input("2", "42") }
      it "should not save the group" do
        shell_output
        Group.count.should == 1
      end
      it "should print an error message" do
        shell_output.should include("'42' is not a valid group name, as it does not include any letters.")
      end
      it "should let them try again" do
        menu_text = "Name of group you would like to add?"
        shell_output.should include_in_order(menu_text, "not a valid", menu_text)
      end
    end
  end
  context "deleting a group" do
    context "delete an existing group" do
      let(:shell_output){ run_rm_with_input("6", "NSS") }
      it "should delete the group" do
        shell_output
        Group.count.should == 0
      end
      it "should display the message of deletion" do
        shell_output.should include("NSS has been deleted.")
      end
    end
    context "if the group deleted does not exist" do
      let(:shell_output){ run_rm_with_input("6", "soggies") }
      it "should not delete the group" do
        shell_output
        Group.count.should == 1
      end
      it "should dispay a message about not existing." do
        shell_output.should include("soggies does not exist.")
      end
    end
  end
end
