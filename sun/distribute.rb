GAME_EXE="main.exe"
OUTPUT_ARTIFACT="haligonia_installer.exe"


# OCRA steps:   ocra main.rb # just exit the game once it loads


# ocra --output haligonia.exe --no-lzma --chdir-first --innosetup haligonia.iss main.rb lib/**/* game-data/**/* glut32.dll OpenAL32.dll
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
