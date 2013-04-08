#! /bin/sh

update_dir=/tmp/crupdate_${RANDOM}
new_rev_file="${update_dir}/rev"
old_rev_file="${HOME}/.cr_rev"
dest_path=/Applications/
base_url="http://commondatastorage.googleapis.com/chromium-browser-snapshots/Mac"

print_help () {
	echo "${0##*/} is a Command Line Updater for the Chromium browser on Mac OSX."
	echo "It uses nightly snapshot builds of the Chromium browser.\n"
	echo "	Commands:"
	echo "		force:	force an upgrade"
	echo "		clean:	remove the revision file and exit"
	echo "		help:	print this message"
	echo "\n	Example usage:"
	echo "		user@host::~$ ChromiumUpdate.sh\n"
}

case ${1} in
	force) rm -f ${old_rev_file};;
	clean) rm -f ${old_rev_file}; exit 0;;
	help) print_help; exit 0;;
esac

mkdir ${update_dir}
curl -s -o ${new_rev_file} ${base_url}/LAST_CHANGE

new_rev=$(<${new_rev_file})
old_rev=0
[ -e ${old_rev_file} ] && old_rev=$(<${old_rev_file})

if (( $new_rev <= $old_rev )); then
	echo "New rev: ${new_rev}, old rev: ${old_rev} ... not updating chromium"
	exit 0
fi

echo "Now fetching Chromium revision ${new_rev}"
curl -o ${update_dir}/chrome-mac.zip ${base_url}/${new_rev}/chrome-mac.zip

echo "Extracting Chromium"
unzip -qq -d ${update_dir} ${update_dir}/chrome-mac.zip

echo "Replacing old version"
cp -fr ${update_dir}/chrome-mac/Chromium.app ${dest_path}

echo ${new_rev} > ${old_rev_file}

echo "Removing temporary directories. Your new chromium is ready to use"
rm -rf ${update_dir}
