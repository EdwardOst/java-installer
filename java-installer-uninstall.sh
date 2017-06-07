function java_installer_install() {
    [[ ${#} < 1 ]] \
        && echo "usage: java_installer_install [repo_dir [target_dir]]" >&2 \
        && return 1

    debugLog "executing: ${FUNCNAME[0]} \"${repo_dir}\" \"${target_dir}\""

    [ -n DEBUG_LOG ] && echo_scope "java_installer"

    # unzip
    tar xzf "jdk-${jdk_filename_version}-linux-x64.tar.gz"

    # remove profile file
    rm -rf "${target_dir}"
    rm -rf "/etc/profile.d/jdk-${jdk_version}.sh"

    # tbd: remove from environment file
#    sudo mv "jdk${jdk_version}" "${target_dir}"
#    echo "JAVA_HOME=/user/bin/java_home" | sudo tee -a /etc/environment
#    echo "JRE_HOME=/usr/bin/java_home/jre" | sudo tee -a /etc/environment

    # remove alternative
    sudo update-alternatives --remove java_home "${target_dir}/jdk${jdk_version}"

}
