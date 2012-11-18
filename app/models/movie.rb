class Movie < ActiveRecord::Base

  class Movie::InvalidKeyError < StandardError ; end

  #Chapter 7 code

  RATINGS = %w[G PG PG-13 R NC-17]  #  %w[] shortcut for array of strings
  validates :title, :presence => true
  validates :release_date, :presence => true
  validate :released_1930_or_later # uses custom validator below
  validates :rating, :inclusion => {:in => RATINGS}, :unless => :grandfathered?
  def released_1930_or_later
    errors.add(:release_date, 'must be 1930 or later') if
      self.release_date < Date.parse('1 Jan 1930')
  end
  def grandfathered? ; self.release_date >= @@grandfathered_date ; end
  
  #Chapter 6 coce

  def self.api_key
    'cc4b67c52acb514bdf4931f7cedfd12b' # replace with YOUR Tmdb key
  end

  def self.find_in_tmdb(string)
    Tmdb.api_key = self.api_key
    begin
      TmdbMovie.find(:title => string)
    rescue ArgumentError => tmdb_error
      raise Movie::InvalidKeyError, tmdb_error.message
    end
  end
  # rest of file elided for brevity
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
end