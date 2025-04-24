#!/usr/bin/env sh

template_dir=./src/templates
templates=($(ls $template_dir))

for template in "${templates[@]}"; do
  nix flake update --flake $template_dir/$template
done
