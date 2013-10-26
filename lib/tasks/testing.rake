namespace :test do
  Rake::TestTask.new(domain: "test:prepare") do |t|
    t.libs << "test"
    t.pattern = 'test/domain/**/*_test.rb'
  end
end

Rake::Task['test'].enhance { Rake::Task["test:domain"].invoke }
