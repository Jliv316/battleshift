class RowSerializer < ActiveModel::Serializer
  alias :read_attribute_for_serialization :send
  attributes :name, :data

  def name
    row_letter = object.first.name[0].downcase
    ["row", row_letter].join("_")
  end

  def data
    object.map do |space|
      SpaceSerializer.new(space).attributes
    end
  end
end
