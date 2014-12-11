class TotalRegexp
  class << self
    def phone
      /\A(13[0-9]|145|147|15[0-3,5-9]|18[0,2,5-9])(\d{8})\z/i
    end

    def email
      /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
    end
  end
end
