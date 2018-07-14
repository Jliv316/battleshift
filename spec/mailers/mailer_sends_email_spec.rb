require 'rails_helper'

describe User do
  let(:user1){ create(:user) }
  let(:user2){ create(:user) }
  let(:game){ create(:game, player_1_id: user1, player_2_id: user2) }
  it "sends an email" do
    expect { BattleshipNotifierMailer.welcome(user1, "http://localhost:3000").deliver_now }.to change { ActionMailer::Base.deliveries.count }.by(1)
    expect { BattleshipNotifierMailer.register("#{user2.username}@gmail.com", user1).deliver_now }.to change { ActionMailer::Base.deliveries.count }.by(1)
    expect { BattleshipNotifierMailer.invitation(user1, user2, game, "http://localhost:3000").deliver_now }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end
end