class Movie < ActiveRecord::Base
  def self.all_ratings 
    ['G','PG','PG-13','R']
  end

  def self.with_ratings(ratings)
   if ratings.nil? or ratings.empty? 
     Movie.all 
   else 
     Movie.where("rating IN (?)", ratings)   
   end 
  end  
end
