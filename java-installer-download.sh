# download jdk from oracle
function java_installer_download() {
    create_user_directory "${java_installer_repo_dir}"
    wget --no-cookies --no-check-certificate --no-clobber \
         --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" \
         --directory-prefix="${java_installer_repo_dir}" \
        "http://download.oracle.com/otn-pub/java/jdk/${java_installer_jdk_filename_version}-${java_installer_jdk_build}/${java_installer_jdk_guid}/jdk-${java_installer_jdk_filename_version}-linux-x64.tar.gz"
}


function java_installer_download_local() {
    set -x
    [ "${#}" -lt 1 ] && echo "ERROR: usage: java_installer_download_local <source_dir>" && return 1
    echo "executing ${@}"
    local java_installer_source_dir="${1}"
    create_user_directory "${java_installer_repo_dir}"
    echo ln -s "${java_installer_source_dir}/jdk-${java_installer_jdk_filename_version}-linux-x64.tar.gz" "${java_installer_repo_dir}/jdk-${java_installer_jdk_filename_version}-linux-x64.tar.gz"
    ln -s "${java_installer_source_dir}/jdk-${java_installer_jdk_filename_version}-linux-x64.tar.gz" "${java_installer_repo_dir}/jdk-${java_installer_jdk_filename_version}-linux-x64.tar.gz"
}
