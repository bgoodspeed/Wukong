GAME_EXE="main.exe"
OUTPUT_ARTIFACT="haligonia_installer.exe"


# OCRA steps:   ocra main.rb # just exit the game once it loads

def do_ocra
	`rm #{GAME_EXE}`
	`ocra main.rb`
end
def zip_up_needed
	do_ocra 
	`zip NONEXEBUNDLE.zip game-data/* #{GAME_EXE}`
	`cat NONEXEBUNDLE.zip patches/unzipsfx.exe > #{OUTPUT_ARTIFACT}`		`zip -A #{OUTPUT_ARTIFACT}`
end

if $0 == __FILE__
	zip_up_needed
end
