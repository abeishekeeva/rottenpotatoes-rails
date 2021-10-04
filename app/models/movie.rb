class Movie < ActiveRecord::Base
  def self.all_ratings 
    ['G','PG','PG-13','R']
  end

  def with_ratings(ratings)
   if not ratings.nil? 
     Movie.where("rating IN (?)", ratings)
   else
     Movie.all
   end 
  end  
end
