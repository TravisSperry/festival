class Student < ApplicationRecord
  GRADES = %w(4th 5th 6th 7th 8th 9th 10th 11th)

  belongs_to :registration, optional: true
end
