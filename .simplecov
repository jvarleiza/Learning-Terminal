SimpleCov.start "rails" do
  # Work in a coverage directory for now, and move everything out later
  coverage_dir File.join("..", "coverage")

  # Hook into SimpleCov after we're done with tests
  at_exit do
    begin
      # Remove our assets folder if it exists (causes issues)
      FileUtils.remove_dir(File.join(coverage_dir, "assets"), force: true)
      # Output our coverage report
      SimpleCov.result.format!
    rescue => e
      puts "Could not generate SimpleCov metrics #{e}"
    end

    # Open the file and write to it
    File.open(File.join("..", "coverage-data.txt"), "w+") do |f|
      f << "ruby:line:#{SimpleCov.result.covered_percent}"
    end
  end
end