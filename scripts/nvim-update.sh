#!/bin/bash

nvim \
  --headless \
  +verbose \
  +'Lazy! sync' \
  +'Lazy! clean' \
  +'Lazy! clear' \
  +'TSUpdateSync' \
  +'autocmd User MasonUpdateAllCompleted qall!' \
  +'MasonUpdateAll'
