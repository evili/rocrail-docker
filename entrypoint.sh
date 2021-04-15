#!/bin/bash
set -euo pipefail
if [[ ! -e svg ]]
then
	ln -svi /opt/rocrail/svg .
fi
/opt/rocrail/bin/rocrail -l /opt/rocrail/bin > /tmp/rocrail.log 2>&1 &
/opt/rocrail/bin/rocview -sp /opt/rocrail/bin -dp /opt/rocrail/demo
