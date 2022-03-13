#!/bin/bash
set -euo pipefail
if [[ ! -e svg ]]
then
	ln -svi /opt/rocrail/svg .
fi
/opt/rocrail/bin/rocrail -l /opt/rocrail/bin
