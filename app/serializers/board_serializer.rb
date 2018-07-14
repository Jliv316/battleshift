class BoardSerializer < ActiveModel::Serializer
  alias :read_attribute_for_serialization :send
  attributes :rows

  def rows
    base_rows = object.spaces.order("name ASC").to_a
    rows = []
    4.times { rows << base_rows.shift(4) }
    rows.map { |row| RowSerializer.new(row).attributes }
  end
end
