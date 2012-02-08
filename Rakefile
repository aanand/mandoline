html = "index.html"
ronn = "README.md"

directory "tmp"

task :default => "tmp" do
  sh "git show master:#{ronn} > tmp/#{ronn}"
  sh "ronn --html --pipe tmp/#{ronn} > #{html}"
end