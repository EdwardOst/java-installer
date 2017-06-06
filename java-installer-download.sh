function java_installer_download() {
    debugLog "executing: ${FUNCNAME[0]} -v \"${java_installer_jdk_version}\" -f \"${java_installer_jdk_filename_version}\" -b \"${java_installer_jdk_build}\" -g \"${java_installer_jdk_guid}\" -t \"${java_installer_target_dir}\""

    # download jdk from oracle
    wget --no-cookies --no-check-certificate --no-clobber \
         --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" \
        "http://download.oracle.com/otn-pub/java/jdk/${java_installer_jdk_filename_version}-${java_installer_jdk_build}/${java_installer_jdk_guid}/jdk-${java_installer_jdk_filename_version}-linux-x64.tar.gz"
}
