require_relative '../spec_helper'

describe Person do
  context ".all" do
    context "with no people in the database" do
      it "should return an empty array" do
        Person.all.should == []
      end
    end
    context "with multiple people in the database" do
      let!(:foo){ Person.create("Foo", "123-456-7890", "foo@noamil.com", "@foo") }
      let!(:bar){ Person.create("Bar", "123-456-7890", "bar@nomail.com", "@bar") }
      let!(:baz){ Person.create("Baz", "123-456-7890", "baz@nomail.com", "@baz") }
      let!(:grille){ Person.create("Grille", "123-456-7890", "grille@nomail.com", "@grille") }
      it "should return all the people" do
        person_attrs = Person.all.map{ |person| [person.name, person.id] }
        person_attrs.should == [["Foo", foo.id],
                                ["Bar", bar.id],
                                ["Baz", baz.id],
                                ["Grille", grille.id]]
      end
    end
  end

  context ".count" do
    context "with no people in the database" do
      it "should return 0" do
        Person.count.should == 0
      end
    end
    context "with multiple people in the database" do
      before do
        Person.new("Foo", "123-456-7890", "foo@nomail.com", "@foo").save
        Person.new("Bar", "123-456-7890", "bar@nomail.com", "@bar").save
        Person.new("Baz", "123-456-7890", "baz@nomail.com", "@baz").save
        Person.new("Grille", "123-456-7890", "grille@nomail.com", "@grille").save
      end
      it "should return the correct count" do
        Person.count.should == 4
      end
    end
  end

  context ".delete_by_name" do
    context "delete 1 person in database" do
      it "should remove person" do
        Person.new("Foo", "123-456-7890", "foo@nomail.com", "@foo").save
        Person.delete_by_name("Foo")
        Person.count.should == 0
      end
    end
  end


  context ".find_by_name" do
    context "with no people in the database" do
      it "should return 0" do
        Person.find_by_name("Foo").should be_nil
      end
    end
    context "with person by that name in the database" do
      let(:foo){ Person.create("Foo","","","") }
      before do
        foo
        Person.new("Bar","","","").save
        Person.new("Baz","","","").save
        Person.new("Grille","","","").save
      end
      it "should return the person with that name" do
        Person.find_by_name("Foo").id.should == foo.id
      end
      it "should return the person with that name" do
        Person.find_by_name("Foo").name.should == foo.name
      end
    end
  end

  context ".last" do
    context "with no people in the database" do
      it "should return nil" do
        Person.last.should be_nil
      end
    end
    context "with multiple people in the database" do
      before do
        Person.new("Foo", "", "", "").save
        Person.new("Bar", "", "", "").save
        Person.new("Baz", "", "", "").save
        Person.new("Grille", "", "", "").save
      end
      it "should return the last one inserted" do
        Person.last.name.should == "Grille"
      end
    end
  end

  context "#new" do
    let(:person){ Person.new("Robert","123-456-7890","robert@nomail.com","@robert") }
    it "should store the name" do
      person.name.should == "Robert"
    end
    it "should store the phone_number" do
      person.phone_number.should == "123-456-7890"
    end
    it "should store the email" do
      person.email.should == "robert@nomail.com"
    end
    it "should store the github account" do
      person.github.should == "@robert"
    end
  end

  context "#create" do
    let(:result){ Environment.database_connection.execute("Select * from people") }
    let(:person){ Person.create("foo", "", "", "") }
    context "with a valid injury" do
      before do
        Person.any_instance.stub(:valid?){ true }
        person
      end
      it "should record the new id" do
        person.id.should == result[0]["id"]
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
        Person.any_instance.stub(:valid?){ false }
        person
      end
      it "should not save a new injury" do
        result.count.should == 0
      end
    end
  end

  context "#save" do
    let(:result){ Environment.database_connection.execute("Select * from people") }
    let(:person){ Person.new("foo", "123-456-7890", "foo@nomail.com", "@foo") }
    context "with a valid person" do
      before do
        person.stub(:valid?){ true }
      end
      it "should only save one row to the database" do
        person.save
        result.count.should == 1
      end
      it "shoudl actually save it to the database" do
        person.save
        result[0]["name"].should == "foo"
      end
      it "should record the new id" do
        person.save
        person.id.should == result[0]["id"]
      end
    end
    context "with an invalid person" do
      before do
        person.stub(:valid?){ false }
      end
      it "should not save a new person" do
        person.save
        result.count.should == 0
      end
    end
    context "editing a person" do
      let(:original_person){ Person.create("foo", "123-456-7890", "foo@nomail.com", "@foo") }
      let!(:original_id){ original_person.id }
      context "valid update" do
        before do
          original_person.name = "bar"
          original_person.save
        end
        let(:updated_person){ Person.find_by_name("bar") }
        it "updated person should not be nil" do
          updated_person.should_not be_nil
        end
        it "updated person should retain previous id" do
          updated_person.id.should == original_id
        end
        it "total number of people should remain constant" do
          Person.count.should == 1
        end
      end
      context "invalid update" do
        let(:duplicate_person){ Person.create("bar", "123-456-7890", "bar@nomail.com", "@bar") }
        before do
          original_person
          duplicate_person.name = "foo"
          duplicate_person.save
        end
        it "should not allow duplicate injury to change to existing name" do
          duplicate_person.errors.first.should == "foo already exists."
        end
        it "should retain number of people in database" do
          Person.count.should == 2
        end
      end
    end
  end

  context "#valid?" do
    let(:result){ Environment.database_connection.execute("Select name from people") }
    context "after fixing the errors" do
      let(:person){ Person.new("123", "", "", "") }
      it "should return true" do
        person.valid?.should be_false
        person.name = "Robert"
        person.valid?.should be_true
      end
    end
    context "with a unique name" do
      let(:person){ Person.new("Joe","" , "", "") }
      it "should return true" do
        person.valid?.should be_true
      end
    end
    context "with a invalid name" do
      let(:person){ Person.new("420", "", "", "") }
      it "should return false" do
        person.valid?.should be_false
      end
      it "should save the error messages" do
        person.valid?
        person.errors.first.should == "'420' is not a valid person name, as it does not include any letters."
      end
    end
    context "with a duplicate name" do
      let(:name){ "Susan" }
      let(:person){ Person.new(name,"","","") }
      before do
        Person.new(name,"","","").save
      end
      it "should return false" do
        person.valid?.should be_false
      end
      it "should save the error messages" do
        person.valid?
        person.errors.first.should == "#{name} already exists."
      end
    end
  end
end
