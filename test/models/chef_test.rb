require 'test_helper'

class ChefTest < ActiveSupport::TestCase
  
  def setup
    @chef = Chef.new(chefname: "Whitny", email: "whitny@example.com", password: "password", password_confirmation: "password")
  end 
  

  test "should be valid" do 
    assert @chef.valid?
  end 
  
  
  test "name should be present" do
    @chef.chefname = " "
    assert_not @chef.valid?
  end 
  
  test "name should be less than 30 characters" do
    @chef.chefname = "a" * 31
    assert_not @chef.valid?
  end 
  
  test "email should be present" do 
    @chef.email = " "
    assert_not @chef.valid?
  end 
  
   test "email should not be too long" do
    @chef.email = "a" * 245 + "example.com"
    assert_not @chef.valid?
  end 
  
  
  test "email should accept correct format" do
    valid_emails = %w[user@example.com WHITNY@gmail.com W.first@yahoo.com john+smith@co.uk.org ]
    valid_emails.each do |valids|
      @chef.email = valids
      assert @chef.valid?, "#{valids.inspect} should be valid"
    end 
  end 
  
  test "should reject invalid email addresses" do 
    invalid_emails = %w[whitny@example whitny@example,com whitny.name@gmail. joe@bar+foo.com]
    invalid_emails.each do |invalids|
      @chef.email = invalids
      assert_not @chef.valid?, "#{invalids.inspect} should be invalid"
    end 
  end 
  
  test "email should be unique and case insensitive" do 
    duplicate_chef = @chef.dup
    duplicate_chef.email = @chef.email.upcase
    @chef.save 
    assert_not duplicate_chef.valid?
  end 
  
  test "email should be lowercase before hitting db" do
    mixed_email = "JohN@Example.com"
    @chef.email = mixed_email
    @chef.save
    assert_equal mixed_email.downcase, @chef.reload.email
  end 
  
  
  test "associated recipes should be destroyed" do 
    @chef.save 
    @chef.recipes.create!(name: "testing destroy", description: "testing destroy function")
    assert_difference "Recipe.count", -1 do 
      @chef.destroy
    end 
  end 
end