#!/usr/bin/env sh

input=$1
template_dir=@template_dir@
templates=($(ls $template_dir))

template_found=false
for template in "${templates[@]}"; do
  if [[ $template == $input ]]; then
    template_found=true
    break
  fi
done

if ! $template_found; then
  echo "\"$input\" is not a valid template choice"
  exit
fi

if [ -f ./.envrc ]; then
  echo ".envrc already found. Moving existing .envrc to .envrc.bak."
  mv .envrc .envrc.bak
fi
cp "$template_dir"/"$template"/.envrc .

if [ -f ./flake.nix ]; then
  echo "flake.nix already found. Moving existing flake.nix to flake.nix.bak"
  mv flake.nix flake.nix.bak
fi
cp "$template_dir"/"$template"/flake.nix .

if [ -f ./flake.lock ]; then
  echo "flake.lock already found. Moving existing flake.lock to flake.lock.bak"
  mv flake.lock flake.lock.bak
fi
cp "$template_dir"/"$template"/flake.lock .

if [ -f ./flake.lock ]; then
  echo ".gitignore already found. Not making any changes to it"
else
  cp "$template_dir"/"$template"/.gitignore .
fi

chmod +w *
chmod +w .*
