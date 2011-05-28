require "spec_query/query/query"
require "spec_query/run/simple_cmd"
require "spec_query/search/search"
require "spec_query/search/grep"
require "spec_query/version"

module SpecQuery
  class SpecRunner
    def run(env)
      query_maker = SpecQuery::Query.new()
      query_maker.other_help = ["Available options:"] +
        search_strategy.available_options.map{|k,v| "#{k}    #{v}"}
      searcher    = search_strategy.new(query_maker.query(env))
      spec_files  = searcher.get_files
      runner      = run_strategy.new(spec_files)
      runner.spec
    end

    private

    # implement other strategy for non-unix
    def search_strategy
      if SpecQuery::Grep.available?
        SpecQuery::Grep
      else
        puts "not implemented, sorry"
        exit 1
      end
    end

    # implement a more sophisticated strategy
    def run_strategy
      SpecQuery::SimpleCmd
    end
  end
end

