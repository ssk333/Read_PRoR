class AddPublisherIdToBooks < ActiveRecord::Migration[5.0]
  def change
    add_reference :books, :publisher, foreign_key: true
  end
end
