class LinkData
  class Meta
    attr_accessor :title, :image_url, :description

    def assign(hash)
      hash.each {|key, value| self.send("#{key}=", value) }
    end
  end
end