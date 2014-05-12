require_relative '../spec_helper'

describe GroupMembership do
  context "#create_for" do
    let(:result){ Environment.database_connection.execute("Select * from group_memberships") }
    let(:person){ Person.new("Robert","","","") }
    let(:group){ Group.new("NSS") }
    before do
      person.save
      group.save
      GroupMembership.create_for(person, group)
    end
    it "should save a new group_membership to the database" do
      result.count.should == 1
    end
    it "should save the foreign key for person" do
      result[0]["person_id"].should == person.id
    end
    it "should save the foreign key for group" do
      result[0]["group_id"].should == group.id
    end
  end
  context "#delete" do
    let(:result){ Environment.database_connection.execute("Select * from group_memberships") }
    let(:person){ Person.new("Robert","","","") }
    let(:group){ Group.new("NSS") }
    before do
      person.save
      group.save
      GroupMembership.create_for(person, group)
    end
    it "should have entered into the database" do
      result.count.should == 1
    end
    it "should delete the record when delete" do
      GroupMembership.delete(person, group)
      result.count.should == 0
    end
  end

  context "find_all_in" do
    let(:result){ Environment.database_connection.execute("Select * from group_memberships") }
    let(:person1){ Person.new("Robert","","","") }
    let(:person2){ Person.new("Amber","","","") }
    let(:person3){ Person.new("Jamison","","","") }
    let(:group1){ Group.new("NSS") }
    let(:group2){ Group.new("soogies") }
    before do
      person1.save
      person2.save
      person3.save
      group1.save
      group2.save
      GroupMembership.create_for(person1, group1)
      GroupMembership.create_for(person1, group2)
      GroupMembership.create_for(person2, group1)
      GroupMembership.create_for(person3, group2)
    end
    it "should pick all in group 1" do
      GroupMembership.find_all_in(group1)[0]["name"] == "Robert"
      GroupMembership.find_all_in(group1)[1]["name"] == "Amber"
    end
    it "should find all groups person 1 is appart of" do
      GroupMembership.find_all_for(person1)[0]["name"] == "NSS"
      GroupMembership.find_all_for(person1)[1]["name"] == "soogies"
    end
    it "should not include third pairing" do
      result.count.should == 4
    end
  end
end
