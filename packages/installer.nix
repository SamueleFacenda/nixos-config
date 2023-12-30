{ stdenv
, writeShellApplication
, git
, gum
}:

writeShellApplication {
  name = "installer";
  runtimeInputs = [ git gum ];
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
        --header="Configuration location (new directory )" )

      if [ -e "$configdir" ]
      then
        echo "Error, path $configdir already exists"
        exit 1
      fi

      # todo check permissions
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

    else
      echo "Select the configuration directory"
      configdir="$(gum file --directory --file=false)"
    fi

    gum style \
      --border double \
      --align center --width 50 --margin "1 2" --padding "1 2" \
    'Now it'"'"'s secrets time! 🗝️
    Generate a keypary (ssh-keygen) for this machine.
    If you are me or someone with access to a machine with a private '\
    'key allowed to edit the secrets, add a public key from this machine to'\
    'the keys in secrets/secrets.nix in the config.
    Then run "agenix --rekey <filename>" on all the secrets
    Important! You must be on a machine with already present keys

    If you are not me, just remove all my public keys from secrets/secrets.nix'\
    ', add yours, delete the secrets (*.age) and recreate them with you secrets.
    Instructions for the secret files format are in secrets/secrets.nix

    Also, create a host copying one of mine and editing the'\
    'hardware config.nix using the one created during the installation!'

    if gum confirm "Activate the config now?"
    then
      hostname="$(gum input --placeholder 'config name(hostname)')"
      sudo nixos-rebuild switch --flake "$configdir#$hostname"
    fi

    echo "Happy hacking!"
  '';
}
