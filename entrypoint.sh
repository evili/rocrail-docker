#!/bin/bash
if [[ ! -e svg ]]
then
	ln -svi /opt/rocrail/svg .
fi
/opt/rocrail/bin/rocview -sp /opt/rocrail/bin
