############## MAC ##################

bin/godot.osx.opt.x86_64:
	scons production=yes arch=x86_64 platform=osx target=release tools=no -j6 custom_modules=../sg-physics-2d/godot/modules/,../godotsteam

# bin/godot.osx.opt.arm64:
# 	scons production=yes arch=arm64 platform=osx target=release tools=no -j6 custom_modules=../sg-physics-2d/godot/modules/ custom_modules=../godotsteam

bin/godot.osx.opt.tools.x86_64:
	scons production=yes arch=x86_64 platform=osx target=release_debug tools=yes -j6 custom_modules=../sg-physics-2d/godot/modules/,../godotsteam

# bin/godot.osx.opt.tools.arm64:
# 	scons production=yes arch=arm64 platform=osx target=release_debug tools=yes -j6 custom_modules=../sg-physics-2d/godot/modules/ custom_modules=../godotsteam

# bin/godot.osx.opt.tools.universal: bin/godot.osx.opt.tools.x86_64 bin/godot.osx.opt.tools.arm64
# 	lipo -create bin/godot.osx.opt.tools.x86_64 bin/godot.osx.opt.tools.arm64 -output bin/godot.osx.opt.tools.universal

# bin/godot.osx.opt.universal: bin/godot.osx.opt.x86_64 bin/godot.osx.opt.arm64
# 	lipo -create bin/godot.osx.opt.x86_64 bin/godot.osx.opt.arm64 -output bin/godot.osx.opt.universal

mac_editor: bin/godot.osx.opt.tools.x86_64
	cp -r misc/dist/osx_tools.app ./Godot.app
	mkdir -p Godot.app/Contents/MacOS
	cp bin/godot.osx.opt.tools.x86_64 Godot.app/Contents/MacOS/Godot
	cp ../godotsteam/sdk/redistributable_bin/osx/libsteam_api.dylib Godot.app/Contents/MacOS/
	chmod +x Godot.app/Contents/MacOS/Godot

mac_export: bin/godot.osx.opt.x86_64
	cp -r misc/dist/osx_template.app .
	mkdir -p osx_template.app/Contents/MacOS
	cp bin/godot.osx.opt.x86_64 osx_template.app/Contents/MacOS/godot_osx_release.64
	#cp bin/godot.osx.opt.debug.universal osx_template.app/Contents/MacOS/godot_osx_debug.64
	chmod +x osx_template.app/Contents/MacOS/godot_osx*
	zip -q -9 -r osx.zip osx_template.app

mac_clean:
	rm bin/godot.osx.opt.x86_64 bin/godot.osx.opt.arm64 bin/godot.osx.opt.tools.x86_64 bin/godot.osx.opt.tools.arm64 bin/godot.osx.opt.tools.universal bin/godot.osx.opt.universal

mac_clean_hard:
	scons production=yes arch=x86_64 platform=osx target=release tools=no -j6 custom_modules=../sg-physics-2d/godot/modules/,../godotsteam -c
	scons production=yes arch=x86_64 platform=osx target=release_debug tools=yes -j6 custom_modules=../sg-physics-2d/godot/modules/,../godotsteam -c

# 	scons production=yes arch=arm64 platform=osx target=release tools=no -j6 custom_modules=../sg-physics-2d/godot/modules/ custom_modules=../godotsteam -c 
# 	scons production=yes arch=arm64 platform=osx target=release_debug tools=yes -j6 custom_modules=../sg-physics-2d/godot/modules/ custom_modules=../godotsteam -c

mac: mac_editor mac_export


############ WINDOWS #################

bin/godot.windows.opt.64.exe:
	scons production=yes platform=windows target=release tools=no -j6 custom_modules=../sg-physics-2d/godot/modules/,../godotsteam use_lto=yes

bin/godot.windows.opt.tools.64.exe:
	scons production=yes platform=windows target=release_debug tools=yes -j6 custom_modules=../sg-physics-2d/godot/modules/,../godotsteam use_lto=yes

windows: bin/godot.windows.opt.64.exe bin/godot.windows.opt.tools.64.exe

windows_editor: bin/godot.windows.opt.tools.64.exe
	mkdir -p bin/windows_editor
	cp bin/godot.windows.opt.tools.64.exe bin/windows_editor/Godot.exe
	cp ../godotsteam/sdk/redistributable_bin/osx/libsteam_api.dylib bin/windows_editor/
	zip -q -9 -r windows_editor.zip bin/windows_editor


windows_editor_clean:
	rm bin/godot.windows.opt.tools.64.exe

windows_clean_hard:
	scons production=yes platform=windows target=release tools=no -j6 custom_modules=../sg-physics-2d/godot/modules/,../godotsteam use_lto=yes -c
	scons production=yes platform=windows target=release_debug tools=yes -j6 custom_modules=../sg-physics-2d/godot/modules/,../godotsteam use_lto=yes -c

windows_clean:
	rm bin/godot.windows.opt.64.exe bin/godot.windows.opt.tools.64.exe


############### ANDROID ################

android:
	scons production=yes platform=android target=release tools=no android_arch=armv7 -j6 custom_modules=../sg-physics-2d/godot/modules/,../godotsteam
	scons production=yes platform=android target=release tools=no android_arch=arm64v8 -j6 custom_modules=../sg-physics-2d/godot/modules/,../godotsteam
	scons production=yes platform=android target=debug tools=no android_arch=armv7 -j6 custom_modules=../sg-physics-2d/godot/modules/,../godotsteam
	scons production=yes platform=android target=debug tools=no android_arch=arm64v8 -j6 custom_modules=../sg-physics-2d/godot/modules/,../godotsteam
	cd platform/android/java && ./gradlew generateGodotTemplates

android_clean:
	rm bin/libgodot.android*

android_clean_hard:
	scons production=yes platform=android target=release tools=no android_arch=armv7 -j6 custom_modules=../sg-physics-2d/godot/modules/,../godotsteam -c
	scons production=yes platform=android target=release tools=no android_arch=arm64v8 -j6 custom_modules=../sg-physics-2d/godot/modules/,../godotsteam -c
	scons production=yes platform=android target=debug tools=no android_arch=armv7 -j6 custom_modules=../sg-physics-2d/godot/modules/,../godotsteam -c
	scons production=yes platform=android target=debug tools=no android_arch=arm64v8 -j6 custom_modules=../sg-physics-2d/godot/modules/,../godotsteam -c
	

############## IOS #################

ios:
	#scons production=yes p=iphone tools=no target=release arch=arm -j6 custom_modules=../sg-physics-2d/godot/modules/,../godotsteam
	scons production=yes p=iphone tools=no target=release arch=arm64 -j6 custom_modules=../sg-physics-2d/godot/modules/,../godotsteam
	#scons p=iphone tools=no ios_simulator=yes target=release arch=x86_64 -j6 custom_modules=../sg-physics-2d/godot/modules/
	#lipo -create bin/libgodot.iphone.opt.arm.a bin/libgodot.iphone.opt.arm64.a bin/libgodot.iphone.opt.x86_64.simulator.a -output bin/libgodot.iphone.release.fat.a
	#lipo -create bin/libgodot.iphone.opt.arm.a bin/libgodot.iphone.opt.arm64.a -output bin/libgodot.iphone.release.fat.a
	chmod +x bin/libgodot.iphone.opt.arm64.a
	cp -R misc/dist/ios_xcode .
	mv ios_xcode iphone
	cp bin/libgodot.iphone.opt.arm64.a iphone/libgodot.iphone.release.xcframework/ios-arm64/libgodot.a
		zip -q -9 -r iphone.zip iphone

ios_clean:
	rm bin/libgodot.iphone.opt.arm.a bin/libgodot.iphone.opt.arm64.a bin/libgodot.iphone.release.fat.a
	rm -rf iphone/
	rm iphone.zip

ios_clean_hard:
	scons production=yes p=iphone tools=no target=release arch=arm -j6 custom_modules=../sg-physics-2d/godot/modules/,../godotsteam -c
	scons production=yes p=iphone tools=no target=release arch=arm64 -j6 custom_modules=../sg-physics-2d/godot/modules/,../godotsteam -c


################ HTML ################

html:
	scons production=yes platform=javascript tools=no threads_enabled=yes target=release -j6 custom_modules=../sg-physics-2d/godot/modules/,../godotsteam
	scons production=yes platform=javascript tools=no threads_enabled=yes target=release_debug -j6 custom_modules=../sg-physics-2d/godot/modules/,../godotsteam
	scons production=yes platform=javascript tools=no threads_enabled=no target=release -j6 custom_modules=../sg-physics-2d/godot/modules/,../godotsteam
	scons production=yes platform=javascript tools=no threads_enabled=no target=release_debug -j6 custom_modules=../sg-physics-2d/godot/modules/,../godotsteam

html_clean:
	rm bin/godot.javascript*

html_clean_hard:
	scons production=yes platform=javascript tools=no threads_enabled=yes target=release -j6 custom_modules=../sg-physics-2d/godot/modules/,../godotsteam -c
	scons production=yes platform=javascript tools=no threads_enabled=yes target=release_debug -j6 custom_modules=../sg-physics-2d/godot/modules/,../godotsteam -c
	scons production=yes platform=javascript tools=no threads_enabled=no target=release -j6 custom_modules=../sg-physics-2d/godot/modules/,../godotsteam -c
	scons production=yes platform=javascript tools=no threads_enabled=no target=release_debug -j6 custom_modules=../sg-physics-2d/godot/modules/,../godotsteam -c


############## LINUX ################

linux:
	docker run --rm -it -v /Users/daviddehaene/Developer/godot:/godot -v /Users/daviddehaene/Developer/sg-physics-2d/godot/modules:/custom_modules -v /Users/daviddehaene/Developer/godotsteam:/godotsteam --platform linux/amd64 ubuntu bash -c "apt -y update; apt -y install clang build-essential scons pkg-config libx11-dev libxcursor-dev libxinerama-dev     libgl1-mesa-dev libglu-dev libasound2-dev libpulse-dev libudev-dev libxi-dev libxrandr-dev yasm; cd /godot; scons production=yes platform=x11 use_llvm=yes target=release tools=no -j6 custom_modules=/custom_modules/,/godotsteam"

linux_clean:
	rm bin/godot.x11.opt.64.llvm

linux_clean_hard:
	docker run --rm -it -v /Users/daviddehaene/Developer/godot:/godot -v /Users/daviddehaene/Developer/sg-physics-2d/godot/modules:/custom_modules -v /Users/daviddehaene/Developer/godotsteam:/godotsteam --platform linux/amd64 ubuntu bash -c "apt -y update; apt -y install clang build-essential scons pkg-config libx11-dev libxcursor-dev libxinerama-dev     libgl1-mesa-dev libglu-dev libasound2-dev libpulse-dev libudev-dev libxi-dev libxrandr-dev yasm; cd /godot; scons production=yes platform=x11 use_llvm=yes target=release tools=no -j6 custom_modules=/custom_modules/,/godotsteam -c"

################ ALL #################

clean: mac_clean windows_clean android_clean ios_clean linux_clean html_clean

clean_hard: mac_clean_hard windows_clean_hard android_clean_hard ios_clean_hard linux_clean_hard html_clean_hard

all: mac windows android ios linux html
