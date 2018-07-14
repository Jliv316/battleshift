class Space < ApplicationRecord
  after_create :init
  belongs_to :ship, optional: true
  belongs_to :board

  def init
    self.result = " "
  end
end