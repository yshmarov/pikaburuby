class Tag < ApplicationRecord
	has_many :post_tags
	has_many :posts, through: :post_tags
	validates :name, length: {minimum: 1, maximum: 25}, uniqueness: true
	def to_s
		name
	end
	def popular_name
	  "#{name.to_s}: #{post_tags_count.to_s}"
	end
end