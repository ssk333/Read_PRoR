class Book < ApplicationRecord
  default_scope -> {order("published_on desc")}
  scope :costly, -> {where("price > ? ",3000)}
  scope :written_about, ->(theme) {where("name like ?","%#{theme}%")}

  belongs_to :publisher

  has_many :book_authors
  has_many :authors,through: :book_authors
end
