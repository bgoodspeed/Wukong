SRCS = GosuImpl/Sockets/CommSocket.cpp GosuImpl/DirectoriesWin.cpp GosuImpl/FileWin.cpp GosuImpl/InputWin.cpp GosuImpl/Inspection.cpp GosuImpl/IO.cpp GosuImpl/Sockets/ListenerSocket.cpp GosuImpl/Math.cpp GosuImpl/Sockets/MessageSocket.cpp GosuImpl/Sockets/Socket.cpp GosuImpl/TextInputWin.cpp GosuImpl/TimingWin.cpp GosuImpl/Utility.cpp GosuImpl/WindowWin.cpp GosuImpl/WinMain.cpp GosuImpl/WinUtility.cpp GosuImpl/Graphics/Bitmap.cpp GosuImpl/Graphics/BitmapColorKey.cpp GosuImpl/Graphics/BitmapFreeImage.cpp GosuImpl/Graphics/BitmapUtils.cpp GosuImpl/Graphics/BlockAllocator.cpp GosuImpl/Graphics/Color.cpp GosuImpl/Graphics/Font.cpp GosuImpl/Graphics/Graphics.cpp GosuImpl/Graphics/Image.cpp GosuImpl/Graphics/LargeImageData.cpp GosuImpl/Graphics/TexChunk.cpp GosuImpl/Graphics/Text.cpp GosuImpl/Graphics/TextTTFWin.cpp GosuImpl/Graphics/Texture.cpp GosuImpl/Graphics/TextWin.cpp GosuImpl/Graphics/Transform.cpp GosuImpl/Audio/AudioSDL.cpp

OBJS = $(SRCS:.cpp=.o)

DXINCLUDE = "C:\Program Files (x86)\Microsoft DirectX SDK (June 2010)\Include"

CXXFLAGS  = -Wall -g -I. -I$(DXINCLUDE) -DUNICODE -D_UNICODE -DMINGW -DWIN32 -D_DEBUG
CXXFLAGS += -Ic:/lib/freeimage/Dist -Ic:/lib/SDL/include/SDL -Ic:/lib/SDL_mixer/include
CXXFLAGS += -Idependencies/libogg/include -Idependencies/libvorbis/include

all: $(OBJS)
	ar rcs lib/libgosu.a $(OBJS)

clean:
	del GosuImpl\*.o


