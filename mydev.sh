#!/usr/bin/env sh

input=$1
langdir=@langdir@
langs=($(ls $langdir))

lang_found=false
for lang in "${langs[@]}"; do
  if [[ $lang == $input ]]; then
    lang_found=true
    break
  fi
done

if ! $lang_found; then
  echo "\"$input\" is not a valid language choice"
  exit
fi

if [ -f ./.envrc ]; then
  echo ".envrc already found. Moving existing .envrc to .envrc.bak."
  mv .envrc .envrc.bak
fi

if [ -f ./flake.nix ]; then
  echo "flake.nix already found. Moving existing flake.nix to flake.nix.bak"
  mv flake.nix flake.nix.bak
fi

cp "$langdir"/"$lang"/flake.nix flake.nix
chmod +w flake.nix

echo "use flake" > .envrc
chmod +w .envrc
