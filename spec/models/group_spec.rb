require_relative '../spec_helper'

describe Group do
  context ".all" do
    context "with no groups in the database" do
      it "should return an empty array" do
        Group.all.should == []
      end
    end
    context "with multiple groups in the database" do
      let!(:foo){ Group.create("Foo") }
      let!(:bar){ Group.create("Bar") }
      let!(:baz){ Group.create("Baz") }
      let!(:grille){ Group.create("Grille") }
      it "should return all the groups" do
        group_attrs = Group.all.map{ |person| [person.name, person.id] }
        group_attrs.should == [["Foo", foo.id],
                                ["Bar", bar.id],
                                ["Baz", baz.id],
                                ["Grille", grille.id]]
      end
    end
  end

  context ".count" do
    context "with no groups in the database" do
      it "should return 0" do
        Group.count.should == 0
      end
    end
    context "with multiple groups in the database" do
      before do
        Group.new("Foo").save
        Group.new("Bar").save
        Group.new("Baz").save
        Group.new("Grille").save
      end
      it "should return the correct count" do
        Group.count.should == 4
      end
    end
  end

  context ".delete_by_name" do
    context "delete 1 group in database" do
      it "should remove a group" do
        Group.new("NSS").save
        Group.delete_by_name("NSS")
        Group.count.should == 0
      end
    end
  end

  context ".find_by_name" do
    context "with no groups in the database" do
      it "should return 0" do
        Group.find_by_name("Foo").should be_nil
      end
    end
    context "with group by that name in the database" do
      let(:foo){ Group.create("Foo") }
      before do
        foo
        Group.new("Bar").save
        Group.new("Baz").save
        Group.new("Grille").save
      end
      it "should return the group with that name" do
        Group.find_by_name("Foo").id.should == foo.id
      end
      it "should return the group with that name" do
        Group.find_by_name("Foo").name.should == foo.name
      end
    end
  end

  context ".last" do
    context "with no groups in the database" do
      it "should return nil" do
        Group.last.should be_nil
      end
    end
    context "with multiple groups in the database" do
      before do
        Group.new("Foo").save
        Group.new("Bar").save
        Group.new("Baz").save
        Group.new("Grille").save
      end
      it "should return the last one inserted" do
        Group.last.name.should == "Grille"
      end
    end
  end

  context "#new" do 
    let(:group){ Group.new("Robert") }
    it "should stor the name" do
      group.name.should == "Robert"
    end
  end

  context "#create" do
    let(:result){ Environment.database_connection.execute("Select * from groups") }
    let(:group){ Group.create("foo") }
    context "with a valid injury" do
      before do
        Group.any_instance.stub(:valid?){ true }
        group
      end
      it "should record the new id" do
        group.id.should == result[0]["id"]
      end
      it "should only save one row to the database" do
        result.count.should == 1
      end
      it "should actually save it to the database" do
        result[0] ["name"].should == "foo"
      end
    end
    context "with an invalid injury" do
      before do
        Group.any_instance.stub(:valid?){ false }
        group
      end
      it "should not save a new injury" do
        result.count.should == 0
      end
    end
  end

  context "#save" do
    let(:result){ Environment.database_connection.execute("Select * from groups") }
    let(:group){ Group.new("foo") }
    context "with a valid group" do
      before do
        group.stub(:valid?){ true }
      end
      it "should only save one row to the database" do
        group.save
        result.count.should == 1
      end
      it "shoudl actually save it to the database" do
        group.save
        result[0]["name"].should == "foo"
      end
      it "should record the new id" do
        group.save
        group.id.should == result[0]["id"]
      end
    end
    context "with an invalid group" do
      before do
        group.stub(:valid?){ false }
      end
      it "should not save a new group" do
        group.save
        result.count.should == 0
      end
    end
    context "editing a group" do
      let(:original_group){ Group.create("foo") }
      let!(:original_id){ original_group.id }
      context "valid update" do
        before do
          original_group.name = "bar"
          original_group.save
        end
        let(:updated_group){ Group.find_by_name("bar") }
        it "updated group should not be nil" do
          updated_group.should_not be_nil
        end
        it "updated group should retain previous id" do
          updated_group.id.should == original_id
        end
        it "total number of groups should remain constant" do
          Group.count.should == 1
        end
      end
      context "invalid update" do
        let(:duplicate_group){ Group.create("bar") }
        before do
          original_group
          duplicate_group.name = "foo"
          duplicate_group.save
        end
        it "should not allow duplicate injury to change to existing name" do
          duplicate_group.errors.first.should == "foo already exists."
        end
        it "should retain number of groups in database" do
          Group.count.should == 2
        end
      end
    end
  end

  context "#valid?" do
    let(:result){ Environment.database_connection.execute("Select name from groups") }
    context "after fixing the errors" do
      let(:group){ Group.new("123") }
      it "should return true" do
        group.valid?.should be_false
        group.name = "Robert"
        group.valid?.should be_true
      end
    end
    context "with a unique name" do
      let(:group){ Group.new("Joe") }
      it "should return true" do
        group.valid?.should be_true
      end
    end
    context "with a invalid name" do
      let(:group){ Group.new("420") }
      it "should return false" do
        group.valid?.should be_false
      end
      it "should save the error messages" do
        group.valid?
        group.errors.first.should == "'420' is not a valid group name, as it does not include any letters."
      end
    end
    context "with a duplicate name" do
      let(:name){ "Susan" }
      let(:group){ Group.new(name) }
      before do
        Group.new(name).save
      end
      it "should return false" do
        group.valid?.should be_false
      end
      it "should save the error messages" do
        group.valid?
        group.errors.first.should == "#{name} already exists."
      end
    end
  end
end
