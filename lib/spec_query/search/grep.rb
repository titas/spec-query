module SpecQuery
  class Grep < Search
    attr_accessor :grep_opts
    GREP_TMP_FILE = ".tests.tmp"

    def self.available?
      system("grep --v > /dev/null")
    end

    def self.available_options
      parent_options = super()
      parent_options[" --r"] = "Use grep regexp subset: https://help.ubuntu.com/community/grep"
      parent_options
    end

    # TODO parse self.options to grep options
    def parse_options
      self.grep_opts = ""
    end

    def get_files_with_regex(regex, options)
      # find all file names in spec/ by regular expression
      # -r => recursive
      # -l => file names with matches
      # write to GREP_TMP_FILE file
      res = system "grep -r -l #{grep_opts} '#{regex}' spec/* | grep _spec.rb > #{GREP_TMP_FILE}"
      read_tmp_file(res, GREP_TMP_FILE)
    end

    def get_with_keyword(keyword, options)
      # find all file names in spec/ that contain keyword.
      # -F => fixed string, not regexp
      # -r => recursive
      # -l => file names with matches
      # -i => ingore case
      # write to GREP_TMP_FILE file
      self.grep_opts += options.include?("--c") ? "" : " -i "
      res = system "grep -F -r -l #{grep_opts} '#{keyword}' spec/* | grep _spec.rb > #{GREP_TMP_FILE}"
      read_tmp_file(res, GREP_TMP_FILE)
    end

    private

    def read_tmp_file(res, file_name)
      unless res
        puts "No maches"
        exit 1
      end
      begin
        file = File.open(file_name, "rb")
        contents = file.read
        file.close
      rescue => e
        puts "Exception: #{e}"
        exit 1
      end
      cleanup
      contents.split("\n")
    end

    def cleanup
      system "rm #{GREP_TMP_FILE}"
    end
  end
end

