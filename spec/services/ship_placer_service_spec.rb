require 'rails_helper'

describe ShipPlacerService do
  before(:each) do
    @user1 = create(:user) 
    @user2 = create(:user, api_key: User.generate_api_key)
    @game = create(:game, player_1_id: @user1, player_2_id: @user2, player_1_api_key: @user1.api_key, player_2_api_key: @user2.api_key)
    @board1 = create(:board, user: @user1, game: @game) 
    create_spaces(@board1)
    @bservice = BoardService.new(@board1)
  end
  it "exists when provided a board and ship" do
    subject = ShipPlacerService.new(@board1, 3, "A1", "A3")
    expect(subject).to be_a ShipPlacerService
  end

  it "places the ship within a row with empty spaces" do
    a1 = @bservice.locate_space("A1")
    a2 = @bservice.locate_space("A2")
    a3 = @bservice.locate_space("A3")
    b1 = @bservice.locate_space("B1")

    expect(a1.ship_id).to be_nil
    expect(a2.ship_id).to be_nil
    expect(a3.ship_id).to be_nil
    expect(b1.ship_id).to be_nil

    result = ShipPlacerService.new(@board1, 3, "A1", "A3")

    a1 = @bservice.locate_space("A1")
    a2 = @bservice.locate_space("A2")
    a3 = @bservice.locate_space("A3")
    b1 = @bservice.locate_space("B1")

    expect(a1.ship_id).to eq(Ship.first.id)
    expect(a2.ship_id).to eq(Ship.first.id)
    expect(a3.ship_id).to eq(Ship.first.id)
    expect(b1.ship_id).to be_nil
    expect(result.message).to eq("Successfully placed ship with a size of 3. You have 1 ship(s) to place with a size of 2.")
  end

  it "places the ship within a column with empty spaces" do
    a1 = @bservice.locate_space("A1")
    b1 = @bservice.locate_space("B1")
    c1 = @bservice.locate_space("C1")
    a2 = @bservice.locate_space("A2")
    b2 = @bservice.locate_space("B2")
    c2 = @bservice.locate_space("C2")

    expect(a1.ship_id).to be_nil
    expect(b1.ship_id).to be_nil
    expect(c1.ship_id).to be_nil
    expect(a2.ship_id).to be_nil
    expect(b2.ship_id).to be_nil
    expect(c2.ship_id).to be_nil

    result = ShipPlacerService.new(@board1, 3, "A1", "C1")

    a1 = @bservice.locate_space("A1")
    b1 = @bservice.locate_space("B1")
    c1 = @bservice.locate_space("C1")
    a2 = @bservice.locate_space("A2")
    b2 = @bservice.locate_space("B2")
    c2 = @bservice.locate_space("C2")

    expect(a1.ship_id).to eq(Ship.first.id)
    expect(b1.ship_id).to eq(Ship.first.id)
    expect(c1.ship_id).to eq(Ship.first.id)
    expect(a2.ship_id).to be_nil
    expect(b2.ship_id).to be_nil
    expect(c2.ship_id).to be_nil
    expect(result.message).to eq("Successfully placed ship with a size of 3. You have 1 ship(s) to place with a size of 2.")
  end

  it "doesn't place the ship if it isn't within the same row or column" do
    expect {
      ShipPlacerService.new(@board1, 3, "A1", "C2")
    }.to raise_error(InvalidShipPlacement)
  end

  it "doesn't place the ship if the space is occupied when placing in columns" do
    ShipPlacerService.new(@board1, 3, "A1", "C1")
    expect {
      ShipPlacerService.new(@board1, 3, "A1", "C1")
    }.to raise_error(InvalidShipPlacement)
  end

  it "doesn't place the ship if the space is occupied when placing in rows" do
    ShipPlacerService.new(@board1, 3, "A1", "A3")
    expect {
      ShipPlacerService.new(@board1, 3, "A1", "A3")
    }.to raise_error(InvalidShipPlacement)
  end

  it "doesn't place the ship if the ship is smaller than the supplied range in a row" do
    expect {
      ShipPlacerService.new(@board1, 2, "A1", "A3")
    }.to raise_error(InvalidShipPlacement)
  end

  it "doesn't place the ship if the ship is smaller than the supplied range in a column" do
    expect {
      ShipPlacerService.new(@board1, 2, "A1", "C1")
    }.to raise_error(InvalidShipPlacement)
  end
end
