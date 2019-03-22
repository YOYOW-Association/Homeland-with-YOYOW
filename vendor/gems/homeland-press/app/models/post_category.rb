class PostCategory < ApplicationRecord
	belongs_to :posts, optional: true
end