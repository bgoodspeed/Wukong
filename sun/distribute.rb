GAME_EXE="haligonia.exe"
OUTPUT_ARTIFACT="HaligoniaInstaller.exe"



def build_win32_installer
	`rm #{GAME_EXE}` if File.exists?(GAME_EXE)
  `cp patches/glut32.dll .`
  `cp patches/OpenAL32.dll .`
	rv_demo2 = `ocra --output haligonia_demo2.exe --no-lzma --chdir-first main2.rb lib/* lib/**/* game-data/**/* game-data/* glut32.dll OpenAL32.dll`
	rv_demo3 = `ocra --output haligonia_demo3.exe --no-lzma --chdir-first main2.rb lib/* lib/**/* game-data/**/* game-data/* glut32.dll OpenAL32.dll`
	rv_demo4 = `ocra --output haligonia_demo4.exe --no-lzma --chdir-first main2.rb lib/* lib/**/* game-data/**/* game-data/* glut32.dll OpenAL32.dll`
	rv_demo5 = `ocra --output haligonia_demo5.exe --no-lzma --chdir-first main2.rb lib/* lib/**/* game-data/**/* game-data/* glut32.dll OpenAL32.dll`
  extras = [ "haligonia_demo2.exe", "haligonia_demo3.exe", "haligonia_demo4.exe", "haligonia_demo5.exe",
    "glut32.dll", "OpenAl32.dll"]
  extra_includes = extras.join(" ")
	rv_main = `ocra --output haligonia.exe --no-lzma --chdir-first --innosetup haligonia.iss main.rb lib/* lib/**/* game-data/**/* game-data/* media/* #{extra_includes}`

  rv_main

end

if $0 == __FILE__

	puts build_win32_installer
end


