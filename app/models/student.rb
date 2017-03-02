class Student < ApplicationRecord
  GRADES = ["4th", "5th", "6th", "7th", "8th", "9th", "10th", "11th"]
  SHIRT_SIZES = ['Youth Large','Adult Small', 'Adult Medium']

  belongs_to :registration, optional: true
end
