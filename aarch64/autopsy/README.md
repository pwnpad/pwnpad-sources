```
# Prepare Ubuntu environment
git clone --depth=1 --branch=autopsy-4.22.1 https://github.com/sleuthkit/autopsy
cd autopsy/
bash linux_macos_install_scripts/install_prereqs_ubuntu.sh

# Download and compile sleuthkit
export TSK_HOME=$PWD/sleuthkit
bash linux_macos_install_scripts/install_tsk_from_src.sh -p $TSK_HOME -b sleuthkit-4.14.0
# Copy bindings for libtsk_jni for aarch64 and arm64
mkdir -p $TSK_HOME/bindings/java/build/NATIVELIBS/aarch64/linux $TSK_HOME/bindings/java/build/NATIVELIBS/arm64/linux
cp $TSK_HOME/bindings/java/build/NATIVELIBS/x86_64/linux/libtsk_jni.so $TSK_HOME/bindings/java/build/NATIVELIBS/aarch64/linux 
cp $TSK_HOME/bindings/java/build/NATIVELIBS/x86_64/linux/libtsk_jni.so $TSK_HOME/bindings/java/build/NATIVELIBS/arm64/linux/
# Recompile it with the the new bindings
cd $TSK_HOME
make
sudo make install

# Compile autopsy. Make sure that the TSK_HOME environment variable is still set, if not the build will fail.
cd .. # Goes back to autopsy directory
ant -Dnbplatform.default.harness.dir=$PWD/netbeans-plat/15/harness build # This will take a long time
# Create autopsy.zip file
ant -Dnbplatform.default.harness.dir=$PWD/netbeans-plat/15/harness suite.build-zip # File will be located in dist/ directory
```
