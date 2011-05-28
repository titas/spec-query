# created by Titas Norkūnas
# run specs by file contents
# searches all spec files for keywords and runs only those specs, that contain them.
# you can use || as OR and && as AND.

require "rubygems"
require "spec_query" # do not load environment == faster

namespace :q do
  # TODO
  # * add more options
  #   ** add option to search in filenames, not only contents
  # * make this work on non-unix
  desc "Query spec: searches all spec files for keywords and runs only those specs, that contain them"
  task :spec do
    spec_runner = SpecQuery::SpecRunner.new
    spec_runner.run(ENV)
  end
end

