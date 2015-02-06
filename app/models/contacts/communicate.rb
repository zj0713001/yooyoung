class Contacts::Communicate < Contacts::Info
  has_many :trades, class_name: Trade
end
