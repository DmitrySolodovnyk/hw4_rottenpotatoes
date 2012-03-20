Given /^the following movies exist:$/ do |movies_table|
  # table is a Cucumber::Ast::Table
  movies_table.hashes.each do |movie|
        Movie.create!(:title=> movie['title'], :rating=> movie['rating'], :director => movie['director'], :release_date=>  movie['release_date']  )
  end
end

Then /^the director of "([^"]*)" should be "([^"]*)"$/ do |movie_title, director|
   movie = Movie.find_by_title(movie_title)
   movie[:director].should == director
end

#And /^I should see "(.*)" has no director info$/ do |movie_title|
#  rows = page.find('#movies').all('tr').map {|element|
#        element.text
#  }
#  print rows
#  #assert values.find_index(e1) < values.find_index(e2), "Wrong order"
#end