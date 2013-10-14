# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie 

Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
 end


 When /^I have added a movie with title "(.*?)" and rating "(.*?)"$/ do |title, rating|
  visit new_movie_path
  fill_in 'Title', :with => title
  select rating, :from => 'Rating'
  click_button 'Save Changes'
 end

 Then /^I should see a movie list entry with title "(.*?)" and rating "(.*?)"$/ do |title, rating| 
   result=false
   all("tr").each do |tr|
     if tr.has_content?(title) && tr.has_content?(rating)
       result = true
       break
     end
   end  
   assert result
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
   click_on "More about #{title}"
 end

Then /^(?:|I )should see "([^"]*)"$/ do |text|
  if page.respond_to? :should
    page.should have_content(text)
  else
    assert page.has_content?(text)
  end
end

 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end





# declarative step for populating the DB with movies.

Given /the following movies have been added to RottenPotatoes:/ do |movies_table|
  movies_table.hashes.each do |movie|
	Movie.create!(movie)
    # Each returned movie will be a hash representing one row of the movies_table
    # The keys will be the table headers and the values will be the row contents.
    # You should arrange to add that movie to the database here.
    # You can add the entries directly to the databasse with ActiveRecord methodsQ
  end
end

When /^I have opted to see movies rated: "(.*?)"$/ do |arg1|
  # HINT: use String#split to split up the rating_list, then
  # iterate over the ratings and check/uncheck the ratings
  # using the appropriate Capybara command(s)
  arg1.split(', ').each {|x|  %{check'#{x}'}}
end

Then /^I should see only movies rated "(.*?)"$/ do |arg1|
  arg1.split(', ').each {|x|  %{check'#{x}'}}
end

Then /^I should see all of the movies$/ do
  rows = page.all('#movies tr').size - 1
	rows.should == Movie.count()
end

When /^(?:|I )follow "([^"]*)"$/ do |location|
  click_link(location)
end

Then /I should see "(.*)" before "(.*)"/ do |a,b|
  regexp = /#{a}.*#{b}/m
  page.body.should =~ regexp
end


