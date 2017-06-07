function java_installer_install() {
    [[ ${#} < 1 ]] \
        && echo "usage: java_installer_install [repo_dir [target_dir]]" >&2 \
        && return 1

    local repo_dir="${1:-${JAVA_INSTALLER_REPO_DIR:-${java_installer_repo_dir:-/opt/repo/java}}}"
    local target_dir="${1:-${JAVA_INSTALLER_REPO_DIR:-${java_installer_target_dir:-/opt/repo/java}}}"
    local jdk_filename_version="${JAVA_INSTALLER_JDK_FILENAME_VERSION:-${java_installer_jdk_filename_version}}"
    local jdk_version="${JAVA_INSTALLER_JDK_VERSION:-${java_installer_jdk_version}}"

    debugLog "executing: ${FUNCNAME[0]} \"${repo_dir}\" \"${target_dir}\""

    # unzip
    tar xzf "jdk-${jdk_filename_version}-linux-x64.tar.gz"

    # append to environment file
    sudo mv "jdk${jdk_version}" "${target_dir}"
    echo "JAVA_HOME=/user/bin/java_home" | sudo tee -a /etc/environment
    echo "JRE_HOME=/usr/bin/java_home/jre" | sudo tee -a /etc/environment

    # create profile.d file
    sudo tee "/etc/profile.d/jdk-${jdk_version}.sh" <<-'EOF'
	JAVA_HOME="/usr/bin/java_home"
	JRE_HOME="${JAVA_HOME}/jre"
	export JAVA_HOME
	export JRE_HOME
	EOF

    # add alternatives and set priorities
    sudo update-alternatives --install /usr/bin/java_home java_home "${target_dir}/jdk${jdk_version}" 999 \
        --slave /usr/bin/java java "${target_dir}/jdk${jdk_version}/bin/java" \
        --slave /usr/bin/javac javac "${target_dir}/jdk${jdk_version}/bin/javac" \
        --slave /usr/bin/jar jar "${target_dir}/jdk${jdk_version}/bin/jar" \

    # select active alternative
    sudo update-alternatives --set java_home "${target_dir}/jdk${jdk_version}"
}
