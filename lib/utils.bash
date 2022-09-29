#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/aws/copilot-cli"
TOOL_NAME="copilot"
TOOL_TEST="copilot --help"

fail() {
  echo -e "asdf-$TOOL_NAME: $*"
  exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if copilot is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

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
  # Change this function if copilot has other means of determining installable versions.
  list_github_tags
}

download_release() {
  local version filename url platform arch platform_type ext
  version="$1"
  filename="$2"
  platform=$(get_platform)
  arch=$(get_arch)
  platform_type=$platform
  ext=""
  if [ "$platform" == "windows" ]; then
    ext=".exe"
  fi
  if { [ "$platform" == "darwin" ] && [ $(numberize_version $version) -ge $(numberize_version "1.10.1") ]; } \
  || { [ "$platform" == "linux" ] && [ $(numberize_version $version) -ge $(numberize_version "0.3.0") ]; }; then
    platform_type="${platform}-${arch}"
  fi

  url="$GH_REPO/releases/download/v${version}/$TOOL_NAME-${platform_type}-v${version}$ext"
  echo "* Downloading $TOOL_NAME release $version from $url ..."
  curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
  local install_type="$1"
  local version="$2"
  local install_path="$3"

  if [ "$install_type" != "version" ]; then
    fail "asdf-$TOOL_NAME supports release installs only"
  fi

  (
    platform=$(get_platform)
    ext=""
    if [ "$platform" == "windows" ]; then
      ext=".exe"
    fi

    mkdir -p "$install_path/bin"
    cp "$ASDF_DOWNLOAD_PATH/$TOOL_NAME$ext" "$install_path/bin/$TOOL_NAME$ext"
    chmod +x "$install_path/bin/$TOOL_NAME$ext"

    local tool_cmd
    tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
    test -x "$install_path/bin/$tool_cmd" || fail "Expected $install_path/bin/$tool_cmd to be executable."

    echo "$TOOL_NAME $version installation was successful!"
  ) || (
    rm -rf "$install_path"
    fail "An error ocurred while installing $TOOL_NAME $version."
  )
}

get_platform() {
  local platform=""

  case "$(uname | tr '[:upper:]' '[:lower:]')" in
    darwin) platform="darwin" ;;
    linux) platform="linux" ;;
    windows) platform="windows" ;;
    *)
      fail "Platform '$(uname)' not supported!"
      ;;
  esac

  echo -n $platform
}

get_arch() {
  local arch=""
  local platform=$(get_platform)

  if [ "$platform" != "windows" ]; then
    case "$(uname -m)" in
      x86_64|amd64) arch="amd64" ;;
      arm64) arch="arm64" ;;
      *)
        fail "Arch '$(uname -m)' not supported!"
        ;;
    esac
  fi

  echo -n $arch
}

numberize_version() {
  echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }'
}
