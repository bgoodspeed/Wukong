GAME_EXE="haligonia.exe"
OUTPUT_ARTIFACT="HaligoniaInstaller.exe"


# OCRA steps:   ocra main.rb # just exit the game once it loads


#

def do_ocra
	`rm #{GAME_EXE}`
  `cp patches/glut32.dll .`
  `cp patches/OpenAL32.dll .`
	rv = `ocra --output haligonia.exe --no-lzma --chdir-first --innosetup haligonia.iss main.rb lib/* lib/**/* game-data/**/* game-data/* glut32.dll OpenAL32.dll`
end

if $0 == __FILE__
	puts do_ocra
end
