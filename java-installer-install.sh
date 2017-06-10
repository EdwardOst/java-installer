function java_installer_install() {
    debugLog "executing: ${FUNCNAME[0]} \"${java_installer_repo_dir}\" \"${java_installer_target_dir}\""

    create_user_directory "${java_installer_target_dir}/jdk${java_installer_jdk_version}"

    # unzip
    tar xzf "${java_installer_repo_dir}/jdk-${java_installer_jdk_filename_version}-linux-x64.tar.gz" \
             --directory "${java_installer_target_dir}"

    # append to environment file
    echo "JAVA_HOME=/user/bin/java_home" | sudo tee -a /etc/environment
    echo "JRE_HOME=/usr/bin/java_home/jre" | sudo tee -a /etc/environment

    # create profile.d file
    sudo tee "/etc/profile.d/jdk-${java_installer_jdk_version}.sh" <<-'EOF'
	JAVA_HOME="/usr/bin/java_home"
	JRE_HOME="${JAVA_HOME}/jre"
	export JAVA_HOME
	export JRE_HOME
	EOF

    # add alternatives and set priorities
    sudo update-alternatives --install /usr/bin/java_home java_home "${java_installer_target_dir}/jdk${java_installer_jdk_version}" 999 \
        --slave /usr/bin/java java "${java_installer_target_dir}/jdk${java_installer_jdk_version}/bin/java" \
        --slave /usr/bin/javac javac "${java_installer_target_dir}/jdk${java_installer_jdk_version}/bin/javac" \
        --slave /usr/bin/jar jar "${java_installer_target_dir}/jdk${java_installer_jdk_version}/bin/jar"

    # select active alternative
    sudo update-alternatives --set java_home "${java_installer_target_dir}/jdk${java_installer_jdk_version}"
}
