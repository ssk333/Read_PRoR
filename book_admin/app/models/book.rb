class Book < ApplicationRecord
  default_scope -> {order("published_on desc")}
  scope :costly, -> {where("price > ? ",3000)}
  scope :written_about, ->(theme) {where("name like ?","%#{theme}%")}

  belongs_to :publisher

  has_many :book_authors
  has_many :authors,through: :book_authors

  validates :name, presence: true
  validates :name, length: {maximum: 15}
  validates :price, numericality:{greater_than_or_equal_to:0}
  validates do |book|
    if book.name.include?("exercise")
      book.errors[:name] << "I don't like exercise."
    end
  end
end
