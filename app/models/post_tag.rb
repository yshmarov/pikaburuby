class PostTag < ApplicationRecord
  belongs_to :tag, counter_cache: true
  belongs_to :post
end