tomcatHomeDir="${1:-"/opt/apache-tomcat-${tomcatVersion}"}"; debugVar _tomcatHomeDir
tacDir="${2:-"/opt/Talend/${TALEND_VERSION}/tac"}"; debugVar _tacDir
tacTomcatDir="${_tacDir}/apache-tomcat"; debugVar _tacTomcatDir

tac_url="http://www.opensourceetl.net/tis/tpdsbdrt_631/Talend-AdministrationCenter-20161216_1026-V6.3.1.zip"


wget "${tac_url}"
