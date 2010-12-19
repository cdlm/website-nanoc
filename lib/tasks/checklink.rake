desc "Check links via W3C Link Validator (slow)."
task :checklink do
	FileList["#{OUT}/**/*.html"].each do |html|
		puts 'Checking: ' + html
		system 'checklink -q -b -s --hide-same-realm ' + html
	end
end
