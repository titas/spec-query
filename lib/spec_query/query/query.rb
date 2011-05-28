module SpecQuery
  class Query
    # require *_query_ext.rb files from spec directory
    @@modules = []
    Dir.new("spec").entries.select{|f| f.end_with?("_query_ext.rb")}.each do |mdl|
      @@modules << (require "spec/#{mdl}")
    end if File.exists?("spec")

    # include specific modules
    @@modules.each do |mdl|
      include Object.const_get(mdl.first) unless mdl == true
    end

    attr_accessor :env, :other_help
    def query(environment)
      self.env = environment
      unless env_condition
        puts help
        exit 1
      else
        query = make_query
      end
      if query.blank?
        puts "No query supplied"
        exit 1
      end
      query
    end

    def help
      ["Please supply query q=query parameter for this rake task",
      "Sample use: rake q:spec q='keyword1&&keyword2||keyword3&&keyword4'"] + (other_help ? other_help : [])
    end

    def env_condition
      env["q"]
    end

    def make_query
      puts "Running specs for: #{env['q']}"
      env["q"]
    end
  end
end

