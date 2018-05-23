require 'rubocop/rake_task'

# run rubocop: rubyenv rake rubocop
# run rubocop with auto correct: rubyenv rake rubocop:auto_correct
RuboCop::RakeTask.new do |task|
  task.patterns = %w[. ../Rakefile]
  task.options += [
    '--rails',
    '--display-style-guide',
    '--display-cop-names',
    '--extra-details'
  ]
end
