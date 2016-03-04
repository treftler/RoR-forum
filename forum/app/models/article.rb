class Article < ActiveRecord::Base
  validates :name, :text, presence: true
end
