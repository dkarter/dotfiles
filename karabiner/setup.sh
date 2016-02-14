#!/bin/sh

cli=/Applications/Karabiner.app/Contents/Library/bin/karabiner

$cli set repeat.wait 33
/bin/echo -n .
$cli set repeat.initial_wait 250
/bin/echo -n .
$cli set remap.sticky_shiftL_lock 1
/bin/echo -n .
$cli set remap.semicolon_x2_to_colon 1
/bin/echo -n .
/bin/echo
