set -e
#set -x

source ../java-installer.sh

#java_installer help
java_installer download_local /home/eost/shared/java
java_installer install
