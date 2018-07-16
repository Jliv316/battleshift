require 'rails_helper'

RSpec.describe Ship, type: :model do
  it { should have_many(:spaces) }
end
