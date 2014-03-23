#!/usr/bin/env bash
# Pre install script to install the a specific version of puppet
# If no parameter is supplied, the lastest version will be installed
VERSION=""
if [ -n "$1" ]
then
        VERSION="$1"
fi
echo "#### START preinstall ####"
PUPPETLABS_RELEASE_INSTALLED=$(dpkg -s puppetlabs-release 2>/dev/null|grep installed)
if [ "$PUPPETLABS_RELEASE_INSTALLED" == "" ]; then
    echo "Installing puppetlabs-release"
    rm -rf /tmp/puppetlabs-release-precise.deb 1>/dev/null 2>&1
    wget -P /tmp http://apt.puppetlabs.com/puppetlabs-release-precise.deb 1>/dev/null 2>&1
    sudo dpkg -i /tmp/puppetlabs-release-precise.deb 1>/dev/null 2>&1
    sudo apt-get update 1>/dev/null 2>&1
    rm -rf /tmp/puppetlabs-release-precise.deb 1>/dev/null 2>&1
fi
echo "Puppetlabs-release installed."
 
# Check if the defined version exists
VERSION_START=0
VERSION_FOUND=0
ALL_VERSIONS=""
 
stripped_info=$(apt-cache showpkg puppet | grep -v '^\( \|$\)' | awk -F, '{ print $1; }')
 
while read line; do
                if [ "$VERSION_START" -eq 1 ]; then
                        case "$line" in
                        *:)
                                VERSION_START=0
                                break
                                ;;
                        esac
                        if [ "Versions:" == "$line" ]; then
                                VERSION_START=1
                        fi
                        line_split=( $line )
                        ALL_VERSIONS="$ALL_VERSIONS${line_split[0]}\n"
                        if [ "${line_split[0]}" == "$VERSION" ]; then
                                VERSION_FOUND=1
                        fi
                fi
                if [ "Versions:" == "$line" ]; then
                        VERSION_START=1
                fi
done <<< "$stripped_info"
 
# If no version was declared install the latest
if [ -z "$VERSION" ]
then
        VERSION=$(echo -e "$ALL_VERSIONS" | head -n 1)
        VERSION_FOUND=1
fi
 
if [ "$VERSION_FOUND" -eq 0 ]; then
        echo
        echo "Error: Supplied version ($VERSION) is not available. Please use one of the following versions:"
        echo -e "$ALL_VERSIONS"
else
        PUPPET_INSTALLED=$(dpkg -s puppet 2>/dev/null|grep -e "installed" -e "Version: $VERSION"|wc -l|grep 2)
 
        if [ "$PUPPET_INSTALLED" == "" ]; then
            echo "Installing puppet version $VERSION"
            apt-get -y --force-yes install puppet-common=$VERSION 1>/dev/null 2>&1
            apt-get -y --force-yes install puppet=$VERSION 1>/dev/null 2>&1
        fi
        PUPPET_VERSION_CHECK=$(puppet --version)
        split_version=(${VERSION//-/ })
        if [ "$PUPPET_VERSION_CHECK" != "${split_version[0]}" ]; then
                echo "Error: Installed version of puppet not matching the install requirement."
        else
                echo "Puppet (${split_version[0]}) successfully installed."
        fi
fi
 
echo "#### END preinstall  ####"
