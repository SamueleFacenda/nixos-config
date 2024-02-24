{ writeShellApplication
, git
, gum
, nixos-install-tools
}:

writeShellApplication {
  name = "installer";
  runtimeInputs = [ git gum nixos-install-tools ];
  text = ''
    set -e
    ORIGIN="https://github.com/SamueleFacenda/nixos-config"

    function dir_permission_check() {
      if [ -e "$1" ]; then
        if [ -d "$1" ] && [ -w "$1" ] && [ -x "$1" ]; then
          return 0
        else
          return 1
        fi
      else
        dir_permission_check "$(dirname "$1")"
        return $?
      fi
    }

    # ask for config dir and ask for clone
    configdir="/nixos-config"

    if gum confirm "Do you want to clone the configuration?"
    then
      configdir=$(gum input --value "$configdir" \
        --header="Configuration location (new directory, absolute path please)" )

      if [ -e "$configdir" ]
      then
        echo "Error, path $configdir already exists"
        exit 1
      fi

      if dir_permission_check "$configdir"
      then
        mkdir -p "$configdir"
      else
        echo "Not enough permission, using sudo"
        sudo mkdir -p "$configdir"
        sudo chown "$(id -nu):$(id -ng)" "$configdir"
        # chmod 774 "$configdir"
      fi

      gum spin --title "Cloning config in $configdir..." \
        git clone "$ORIGIN" "$configdir"

      # patch the flake local path reference
      # TODO think about relative paths
      sed -i "s#/nixos-config#$configdir#g" "$configdir/modules/nixos.nix"

    else
      echo "Select the configuration directory"
      configdir="$(gum file --directory --file=false)"
    fi

    echo "Enter a hostname for this machine"
    hostname="$(gum input --placeholder 'config name(hostname)')"

    # generate the host config
    cp -r "$configdir/host/genericLinux" "$configdir/host/$hostname"
    sed -i "s/nixos-samu/$hostname/g" "$configdir/host/$hostname/default.nix"

    echo "Enter a username"
    username="$(gum input --placeholder 'samu')"
    sed -i "s/samu/$username/g" "$configdir/host/$hostname/default.nix"

    echo "Enter a long name"
    longname="$(gum input --placeholder 'Samuele Facenda')"
    sed -i "s/Samuele Facenda/$longname/g" "$configdir/host/$hostname/default.nix"

    # generate hardware config
    tempDir="$(mktemp -d)"
    nixos-generate-config --dir "$tempDir"
    cp "$tempDir/hardware-configuration.nix" "$configdir/host/$hostname"


    # add to git the config (required for flakes)
    (cd "$configdir"; git add "host/$hostname/*")

    gum style \
      --border double \
      --align center --width 50 --margin "1 2" --padding "1 2" \
    'The secrets are disable by default. Generate a ssh keypair and do a rekey with that keys, '\
    'then enable them in the host config (or set the placehorders around the config, '\
    'just git grep for "placehoder")'

    if gum confirm "Activate the config now?"
    then
      sudo nixos-rebuild switch --flake "$configdir#$hostname"
    fi

    echo "Happy hacking!"
  '';
}
