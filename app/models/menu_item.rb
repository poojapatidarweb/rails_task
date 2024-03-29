# frozen_string_literal: true

# menu item
class MenuItem < ApplicationRecord
  self.table_name = 'menu_item'
  validates :category, presence: true
  validates :name, presence: true
  belongs_to :restaurant
  paginates_per 5
  def self.filter_by_query(search_query)
    where('name LIKE :query OR description LIKE :query', query: "%#{search_query}%")
  end
end
