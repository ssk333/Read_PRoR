class Book < ApplicationRecord
  default_scope -> {order("published_on desc")} 
  scope :costly, -> {where("price > ? ",3000)}
  scope :written_about, ->(theme) {where("name like ?","%#{theme}%")}
end
