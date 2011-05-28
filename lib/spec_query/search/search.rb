module SpecQuery
  class Search
    # original options, original query
    attr_accessor :options, :query

    def self.available_options
      {" --c" => "Case sensitive", " --r" => "Use regexp"}
    end

    def initialize(query)
      self.query, self.options = split_query(query)
    end

    def get_files
      parse_options
      if options.include?("--r")
        get_files_with_regex(query, options)
      else
        get_files_with_keywords(query, options)
      end
    end

    protected

    # TODO
    # * use some library for parsing this
    def split_query(original_query)
      options = []
      query = original_query
      self.class.available_options.keys.each do |o|
        if original_query.include?(o)
          query = query.gsub(o, "")
          options << o.strip
        end
      end
      [query, options]
    end

    def get_files_with_keywords(keywords, options)
      files = []
      # keyword1&&keyword2||keyword3&&keyword4
      keywords.split("||").each do |keywords_and|
        # [keyword1&&keyword2, keyword3&&keyword4]
        files_and = []
        keywords_and.split("&&").each_with_index do |k, i|
          # [[keyword1, keyword2], [keyword3, keyword4]]
          if i == 0 # first time just add
            files_and = get_with_keyword(k, options)
          else # use & for getting only what we were requested
            files_and = files_and & get_with_keyword(k, options)
          end
        end
        files << files_and
      end
      files.flatten.uniq
    end
  end
end

