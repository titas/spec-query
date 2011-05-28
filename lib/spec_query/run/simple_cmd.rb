module SpecQuery
  class SimpleCmd
    attr_accessor :files
    def initialize(files)
      self.files = files
    end

    def spec
      if files.present?
        puts "Matched specs: #{files.size}"
        puts files
        system "ruby -Itest -Ispec #{files.join(' ')}"
      else
        puts "No maches"
      end
    end
  end
end

