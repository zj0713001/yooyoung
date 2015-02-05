class Contacts::Communicate < Contacts::Info
  has_many :trades, user_name: Trade
end
