#!/bin/bash


usage()
{
	echo "Usage: $0 [OPTIONS]"
	echo
	echo "-h: help"
	echo "-v: verbose"
	echo "-d: dryrun"
}

run_command()
{
	local command_to_run=$1

	if [ "$DRY_RUN" = "true" ]; then
		echo "(DRY RUN) $command_to_run"
	else
		[ "$VERBOSE" = "true" ] && echo "$command_to_run"
		(eval "$command_to_run")
	fi
}

backup_file()
{
	local file=$1
	local backup_suffix="bkp_by_script"
	echo "Backup $file"
	[[ ! -f "$file" && ! -d "$file" ]] && return 0
	[ -h "$file" ] && return 0
	[[ -f "$file.$backup_suffix" || -d "$file.$backup_suffix" ]] && return 0
	run_command "mv '$file' '$file.$backup_suffix'"
}

handle_user_policy()
{
	local user_policy=$1
	local file=$2

	if [ "${UID}" != "0" ]; then
		if [ "$user_policy" = "$POLICY_ROOT_ONLY" ]; then
			echo "$INFO_PREFIX: The file/directory '$file', should only be setup as root"
			return 1
		fi
	else 
		if [ "$user_policy" = "$POLICY_USER_ONLY" ]; then
			echo "$INFO_PREFIX: The file/directory '$file', should only be setup as normal user"
			return 1
		fi
	fi

	return 0
}

setup_config_dir()
{
	local dir=$1
	local user_policy=$2
	
	handle_user_policy "$user_policy" "$dir"
	[ $? != "0" ] && return 0

	run_command "mkdir -p '$dir'"
}

setup_setup_list()
{
	local path=$1
	local name=$2
	local command_to_execute=$3
	local user_policy=$4

	handle_user_policy "$user_policy" "$path/$name"
	[ $? != "0" ] && return 0

	if [ ! -d "$path/$name" ]; then
		echo "Downloading $name plugin/theme into $path/$name"
		run_command "cd '$path' && eval '$command_to_execute'"
	else
		echo "The plugin/theme '$path/$name' already exists"
	fi
}

setup_config_file()
{
	local source_file=$1
	local linked_file=$2
	local user_policy=$3
	local backup_policy=$4

	handle_user_policy "$user_policy" "$linked_file"
	[ $? != "0" ] && return 0

	if [ "$backup_policy" = "true" ]; then
		backup_file "$linked_file"
	fi

	if [[ ! -d "$linked_file" || -h "$linked_file" ]]; then
		run_command "rm -f '$linked_file'"
	else
		run_command "rmdir '$linked_file'"
	fi
	
	if [ "${UID}" != "0" ]; then
		echo "$INFO_PREFIX: Linking '$linked_file' to '$source_file'"
		run_command "ln -s '$source_file' '$linked_file'"
	else
		echo "$INFO_PREFIX: Copying '$source_file' to '$linked_file'"
		run_command "cp -f '$source_file' '$linked_file'"
		# If we only run this as root, we should make it readable for everyone
		[ "$user_policy" = "$POLICY_ROOT_ONLY" ] && run_command "chmod go+rX '$linked_file'"
	fi
}


DRY_RUN="false"
VERBOSE="false"

while getopts dvh name; do
	case $name in
		d)
			DRY_RUN="true"
			;;
		v)
			VERBOSE="true"
			;;
		h)
			usage
			exit 0
			;;
		?) ;;
	esac
done

SCRIPT_ROOT_PATH="$(dirname $(realpath -s "$0"))"
SCRIPT_HOME_DIR="/home/$(ls -ld "$0" | awk '{print $3}')"
INFO_PREFIX="Running as ${USER}"
POLICY_BOTH=0
POLICY_USER_ONLY=1
POLICY_ROOT_ONLY=2

while IFS= read -r line; do
	user_policy="${line%|*}"
	dir="$(eval echo "${line#*|}")"

	setup_config_dir "$dir" "$user_policy"
done < config_dir_list

while IFS= read -r line; do
	user_policy="${line%%|*}"
	line="${line#*|}"
	path="$(eval echo "${line%%|*}")"
	line="${line#*|}"
	name="${line%|*}"
	command_to_execute="${line#*|}"

	setup_setup_list "$path" "$name" "$command_to_execute" "$user_policy"
done < config_setup_list

while IFS= read -r line; do
	user_policy="${line%%|*}"
	line="${line#*|}"
	backup_policy="${line%%|*}"
	line="${line#*|}"
	source_file="$(eval echo "${line%|*}")"
	linked_file="$(eval echo "${line#*|}")"
	
	setup_config_file "$source_file" "$linked_file" "$user_policy" "$backup_policy"
done < config_file_list

