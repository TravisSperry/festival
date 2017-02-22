class Registration < ApplicationRecord

  validates_presence_of :first_name, :last_name, :email, :phone
  has_many :students

  accepts_nested_attributes_for :students, :reject_if => lambda { |a| a[:first_name].blank? && a[:last_name].blank? }

  YEAR = 2017

  def save_with_payment
    if valid?
      charge_total = total
      charge = Stripe::Charge.create(
                                      amount: charge_total,
                                      currency: "usd",
                                      card: stripe_card_token,
                                      description: "Registration for #{student_count} student(s)."
                                    )
      self.stripe_charge_token = charge.id
      save!
    end
  end

  def save_without_payment
    if valid?
      save!
    end
  end
end