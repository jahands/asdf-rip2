#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/MilesCranmer/rip2"
TOOL_NAME="rip2"
TOOL_TEST="rip --version"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

get_platform() {
	local os arch
	os=$(uname -s | tr '[:upper:]' '[:lower:]')
	arch=$(uname -m)
	
	case "$os" in
		darwin)
			case "$arch" in
				x86_64) echo "macOS-Darwin-x86_64" ;;
				arm64) echo "macOS-Darwin-aarch64" ;;
				*) fail "Unsupported architecture: $arch on $os" ;;
			esac
			;;
		linux)
			case "$arch" in
				x86_64) echo "Linux-x86_64-musl" ;;
				aarch64) echo "Linux-aarch64-musl" ;;
				armv7l|arm) echo "Linux-arm-musl" ;;
				i686|i386) echo "Linux-i686-musl" ;;
				ppc|powerpc) echo "Linux-powerpc-gnu" ;;
				ppc64) echo "Linux-powerpc64-gnu" ;;
				ppc64le) echo "Linux-powerpc64le" ;;
				s390x) echo "Linux-s390x-gnu" ;;
				*) fail "Unsupported architecture: $arch on $os" ;;
			esac
			;;
		freebsd)
			case "$arch" in
				x86_64) echo "FreeBSD-x86_64" ;;
				*) fail "Unsupported architecture: $arch on $os" ;;
			esac
			;;
		mingw*|msys*|cygwin*)
			case "$arch" in
				x86_64) echo "Windows-x86_64" ;;
				i686|i386) echo "Windows-i686" ;;
				*) fail "Unsupported architecture: $arch on $os" ;;
			esac
			;;
		*)
			fail "Unsupported operating system: $os"
			;;
	esac
}

get_download_extension() {
	local platform="$1"
	case "$platform" in
		Windows-*) echo "zip" ;;
		*) echo "tar.gz" ;;
	esac
}

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
	list_github_tags
}

download_release() {
	local version filename url platform extension
	version="$1"
	filename="$2"
	
	platform=$(get_platform)
	extension=$(get_download_extension "$platform")
	url="$GH_REPO/releases/download/v${version}/rip-${platform}.${extension}"

	echo "* Downloading $TOOL_NAME release $version for $platform..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		
		# Copy the rip binary from download path to install path
		cp "$ASDF_DOWNLOAD_PATH/rip" "$install_path/" || fail "Could not copy rip binary"
		
		# Ensure the binary is executable
		chmod +x "$install_path/rip" || fail "Could not make rip binary executable"

		# Verify the binary works
		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
