set -e
# set -x

[ "${JAVA_INSTALLER_FLAG:-0}" -gt 0 ] && return 0

export JAVA_INSTALLER_FLAG=1

java_installer_script_path=$(readlink -e "${BASH_SOURCE[0]}")
java_installer_script_dir="${java_installer_script_path%/*}"

java_installer_util_path=$(readlink -e "${java_installer_script_dir}/util/util.sh")
source "${java_installer_util_path}"

java_installer_parse_args_path=$(readlink -e "${java_installer_script_dir}/util/parse-args.sh")
source "${java_installer_parse_args_path}"

java_installer_scope_context_path=$(readlink -e "${java_installer_script_dir}/util/scope-context.sh")
source "${java_installer_scope_context_path}"

java_installer_url_path=$(readlink -e "${java_installer_script_dir}/util/url.sh")
source "${java_installer_url_path}"

java_installer_install_path=$(readlink -e "${java_installer_script_dir}/java-installer-install.sh")
source "${java_installer_install_path}"

java_installer_download_path=$(readlink -e "${java_installer_script_dir}/java-installer-download.sh")
source "${java_installer_download_path}"

define java_installer_init <<'EOF'
    local java_installer_repo_dir="${JAVA_INSTALLER_REPO_DIR:-${java_installer_repo_dir:-/opt/repo/java}}"
    local java_installer_target_dir="${JAVA_INSTALLER_REPO_DIR:-${java_installer_repo_dir:-/opt}}"
    local java_installer_jdk_filename_version="${JAVA_INSTALLER_JDK_FILENAME_VERSION:-${java_installer_jdk_filename_version:-8u131}}"
    local java_installer_jdk_version="${JAVA_INSTALLER_JDK_VERSION:-${java_installer_jdk_version:-1.8.0_131}}"
    local java_installer_jdk_build="${JAVA_INSTALLER_JDK_BUILD:-${java_installer_jdk_build:-b11}}"
    local java_installer_jdk_guid="${JAVA_INSTALLER_JDK_GUID:-${java_installer_jdk_guid:-d54c1d3a095b4ff2b6607d096fa80163}}"
    local java_installer_config="java_installer_context"
EOF

declare -A java_installer_context=(
                                    [repo_dir]="${JAVA_INSTALLER_REPO_DIR:-${java_installer_repo_dir:-/opt/repo/java}}"
                                    [target_dir]="${JAVA_INSTALLER_REPO_DIR:-${java_installer_repo_dir:-/opt}}"
                                    [jdk_filename_version]="${JAVA_INSTALLER_JDK_FILENAME_VERSION:-${java_installer_jdk_filename_version:-8u131}}"
                                    [jdk_version]="${JAVA_INSTALLER_JDK_VERSION:-${java_installer_jdk_version:-1.8.0_131}}"
                                    [jdk_build]="${JAVA_INSTALLER_JDK_BUILD:-${java_installer_jdk_build:-b11}}"
                                    [jdk_guid]="${JAVA_INSTALLER_JDK_GUID:-${java_installer_jdk_guid:-d54c1d3a095b4ff2b6607d096fa80163}}"
                                  )

source /dev/stdin <<<"${java_installer_init_context}"

function java_installer_help() {
    _help_flag=1
    cat <<-EOF
	Install Java

	usage
	    java-installer [options] <command> [command_options]

	    options:
	        -h help
                -c specify an alternate configuration

	commands:
	    download
	    install
	    uninstall
	    help

	download:
	    java-installer download [-v jdk_version] [-f jdk_filename_version] [-b jdk_build] [-g jdk_guid] [-r jdk_repo_dir]

	    options:
	        -v jdk_version="1.8.0_131"
	        -f jdk_filename_version="8u131"
	        -b jdk_build="b11"
	        -g jdk_guid="d54c1d3a095b4ff2b6607d096fa80163"
	        -r jdk_repo_dir="/opt/repo/java"

	install:
	    java-installer install [-r repo_dir] [-t target_dir]

	    options:
	        -r jdk_repo_dir="/opt/repo/java"
	        -t jdk_target_dir="/opt"

	unistall:
	    java-installer uninstall [-t target_dir]

	    options:
	        -t jdk_target_dir="/opt"

	EOF
}

function java_installer() {


    declare -A java_installer_options=(
                          ["-b"]="java_installer_jdk_build"
                          ["--build"]="java_installer_jdk_build"
                          ["-c"]="java_installer_config"
                          ["--config"]="java_installer_config"
                          ["-g"]="java_installer_jdk_guid"
                          ["--guid"]="java_installer_jdk_guid"
                          ["-r"]="java_installer_jdk_repo_dir"
                          ["--repo_dir"]="java_installer_jdk_repo_dir"
                          ["-t"]="jdk_target_dir"
                          ["--target"]="jdk_target_dir"
                          ["-v"]="java_installer_jdk_version"
                          ["--jdk_version"]="java_installer_jdk_version"
                         )

    declare -A java_installer_exec_options=(
                          ["-c"]="load_config"
                          ["--config"]="load_config"
                         )

    declare -A java_installer_args

    declare -A java_installer_subcommands=(
                                            ["download"]="java_installer_download"
                                            ["install"]="java_installer_install"
                                            ["uninstall"]="java_installer_uninstall"
                                            ["help"]="java_installer_help"
                                          )

    declare -A java_installer_descriptions=(
                          ["-b"]="java_installer_jdk_build"
                          ["--build"]="java_installer_jdk_build"
                          ["-g"]="java_installer_jdk_guid"
                          ["--guid"]="java_installer_jdk_guid"
                          ["-r"]="java_installer_jdk_repo_dir"
                          ["--repo_dir"]="java_installer_jdk_repo_dir"
                          ["-t"]="jdk_target_dir"
                          ["--target"]="jdk_target_dir"
                          ["-v"]="java_installer_jdk_version"
                          ["--jdk_version"]="java_installer_jdk_version"
                          ["download"]="Download java developers kit from Oracle to local file system"
                          ["install"]="Install jdk, initial update-alternatives,  and configure environment settings for JAVA_HOME and PATH"
                          ["uninstall"]="Remove jdk, clear environent settings, and unset update-alternatives"
                         )

    local optindex
    local -a java_installer_command

    source /dev/stdin <<<"${java_installer_init}"
    load_context

    parse_args java_installer_command \
               optindex \
               java_installer_options \
               java_installer_exec_options \
               java_installer_args \
               java_installer_subcommands \
               java_installer_descriptions \
               "${@}"
    shift "${optindex}"
    [ "${#java_installer_command[@]}" == 0 ] && java_installer_help && return 0

    [ -n "${DEBUG_LOG}" ] && echo_scope

    "${java_installer_command[@]}"
}
