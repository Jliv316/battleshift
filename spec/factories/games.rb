FactoryBot.define do
  factory :game do
    player_1_id {rand(1..10)}
    player_2_id {rand(11..20)}
    winner nil
    player_1_turns 0
    player_2_turns 0
    current_turn ""
  end
end
