############## MAC ##################

bin/godot.osx.opt.64:
	scons platform=osx target=release tools=no -j6 custom_modules=../sg-physics-2d/godot/modules/

bin/godot.osx.opt.tools.64:
	scons platform=osx target=release_debug tools=yes -j6 custom_modules=../sg-physics-2d/godot/modules/

mac_editor: bin/godot.osx.opt.tools.64
	cp -r misc/dist/osx_tools.app ./Godot.app
	mkdir -p Godot.app/Contents/MacOS
	cp bin/godot.osx.opt.tools.64 Godot.app/Contents/MacOS/Godot
	chmod +x Godot.app/Contents/MacOS/Godot

mac_export: bin/godot.osx.opt.64
	cp -r misc/dist/osx_template.app .
	mkdir -p osx_template.app/Contents/MacOS
	cp bin/godot.osx.opt.64 osx_template.app/Contents/MacOS/godot_osx_release.64
	#cp bin/godot.osx.opt.debug.universal osx_template.app/Contents/MacOS/godot_osx_debug.64
	chmod +x osx_template.app/Contents/MacOS/godot_osx*
	zip -q -9 -r osx.zip osx_template.app

mac_clean:
	rm bin/godot.osx.opt.64 bin/godot.osx.opt.tools.64

mac: mac_editor mac_export


############ WINDOWS #################

bin/godot.windows.opt.64.exe:
	scons platform=windows target=release tools=no -j6 custom_modules=../sg-physics-2d/godot/modules/ use_lto=yes

bin/godot.windows.opt.tools.64.exe:
	scons platform=windows target=release_debug tools=yes -j6 custom_modules=../sg-physics-2d/godot/modules/ use_lto=yes

windows: bin/godot.windows.opt.64.exe bin/godot.windows.opt.tools.64.exe

windows_editor: bin/godot.windows.opt.tools.64.exe

windows_editor_clean:
	rm bin/godot.windows.opt.tools.64.exe

windows_clean:
	rm bin/godot.windows.opt.64.exe bin/godot.windows.opt.tools.64.exe


############### ANDROID ################

android:
	scons platform=android target=release tools=no android_arch=armv7 -j6 custom_modules=../sg-physics-2d/godot/modules/
	scons platform=android target=release tools=no android_arch=arm64v8 -j6 custom_modules=../sg-physics-2d/godot/modules/
	cd platform/android/java && ./gradlew generateGodotTemplates

android_clean:
	rm bin/libgodot.android*


############## IOS #################

ios:
	scons p=iphone tools=no target=release arch=arm -j6 custom_modules=../sg-physics-2d/godot/modules/
	scons p=iphone tools=no target=release arch=arm64 -j6 custom_modules=../sg-physics-2d/godot/modules/
	lipo -create bin/libgodot.iphone.opt.arm.a bin/libgodot.iphone.opt.arm64.a -output bin/libgodot.iphone.release.fat.a
	chmod +x bin/libgodot.iphone.release.fat.a
	cp -R misc/dist/ios_xcode .
	mv ios_xcode iphone
	cp bin/libgodot.iphone.release.fat.a iphone/libgodot.iphone.release.xcframework/ios-arm64/libgodot.a
		zip -q -9 -r iphone.zip iphone

ios_clean:
	rm bin/libgodot.iphone.opt.arm.a bin/libgodot.iphone.opt.arm64.a bin/libgodot.iphone.release.fat.a
	rm -rf iphone/
	rm iphone.zip


################ HTML ################

html:
	scons platform=javascript tools=no threads_enabled=yes target=release -j6 custom_modules=../sg-physics-2d/godot/modules/
	scons platform=javascript tools=no threads_enabled=yes target=release_debug -j6 custom_modules=../sg-physics-2d/godot/modules/
	scons platform=javascript tools=no threads_enabled=no target=release -j6 custom_modules=../sg-physics-2d/godot/modules/
	scons platform=javascript tools=no threads_enabled=no target=release_debug -j6 custom_modules=../sg-physics-2d/godot/modules/

html_clean:
	rm bin/godot.javascript*


################ ALL #################

clean: mac_clean windows_clean android_clean ios_clean html_clean

all: mac windows android ios html
