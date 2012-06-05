GAME_EXE="haligonia.exe"
OUTPUT_ARTIFACT="HaligoniaInstaller.exe"



def build_win32_installer
	`rm #{GAME_EXE}`
  `cp patches/glut32.dll .`
  `cp patches/OpenAL32.dll .`
	rv = `ocra --output haligonia.exe --no-lzma --chdir-first --innosetup haligonia.iss main.rb lib/* lib/**/* game-data/**/* game-data/* glut32.dll OpenAL32.dll`
end

if $0 == __FILE__
	puts build_win32_installer
end


