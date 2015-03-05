require 'hashids'

module Hashid
  module ClassMethods
    def hashids
      @hashids ||= Hashids.new(self.class.name, 10)
    end

    def encrypt_id(id)
      hashids.encode(id)
    end

    def decrypt_id(id)
      hashids.decode(id).first
    end

    def find_by_param(id)
      self.find_by(id: self.decrypt_id(id))
    end
  end

  def self.included(base)
    base.extend ClassMethods
  end

  def encrypted_id
    self.class.encrypt_id(id)
  end

  def to_param
    encrypted_id
  end
end
