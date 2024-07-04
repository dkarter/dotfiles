#!/bin/bash

nvim \
  --headless \
  +verbose \
  +'Lazy! sync' \
  +'Lazy! clean' \
  +'Lazy! clear' \
  +'TSUpdateSync' \
  +'MasonUpdateAll' \
  +'qall!'
