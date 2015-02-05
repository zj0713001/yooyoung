class Contacts::Attendence < Contacts::Info
  has_and_belongs_to_many :trades, uniq: true, class_name: Trade
end
