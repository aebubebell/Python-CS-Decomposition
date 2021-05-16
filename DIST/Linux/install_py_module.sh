#!/bin/bash

# For Linux
CUNCSDMODULE=cuncsd.cpython-35m-x86_64-linux-gnu.so  
CUNCSD_SQ_MODULE=cuncsd_sq.cpython-35m-x86_64-linux-gnu.so
command -v conda-env -h ls >/dev/null 2>&1 || { printf >&2 "Command line tool 'conda-env' is not available.\nThis modul requires Anaconda Python 3.5 or newer.\nPlease check if you have Anaconda Python installed, and on the \$PATH variable!\n\n"; exit 1; }


EXPORTFILE=/tmp/exportfile${RANDOM}

conda-env list | {
  while IFS= read -r line
  do
      if echo x"$line" | grep '*' > /dev/null; then
	  lastline="$line"
      fi 
  done
  for mEach in $lastline
  do
      CondaPath="$mEach"
  done

  # This won't work without the braces.
  echo $CondaPath > $EXPORTFILE
  exit 1;
}
CondaPath=$(cat $EXPORTFILE)
if [[ $1 != "-s"  ]]; then
	read -p "Found Anaconda Python install path '$CondaPath'. Is this correct? [Y|n]" -n 1 -r
else
	echo "Using Anaconda Python install path '$CondaPath'."
	REPLY='Y'
fi
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Nn]$ ]];
then
    if [ -d "$CondaPath/bin" ]; then
	# Control will enter here if $DIRECTORY exists.
	echo "Confirmed Python '$CondaPath/bin' directory."
    else
	echo "ERROR: Python 'bin' directory is missing."
	exit 1;
    fi
    if [ -d "$CondaPath/lib" ]; then
	# Control will enter here if $DIRECTORY exists.
	echo "Confirmed Python '$CondaPath/lib' directory."
    else
	echo "ERROR: Python '$CondaPath/lib' directory is missing."
	exit 1;
    fi
    FullPyVersion=$(($CondaPath/bin/python -V) 2>&1)
    PyVStr=${FullPyVersion%:: *}
    V="3.5"
    if [ "$PyVStr" == "Python 3.5.2 " ]; then 
       echo "Found matching $PyVStr."
    else
       echo "WARNING: This module has only been tested with Anaconda Python 3.5.2 but detected $PyVStr(!)"
       V=${PyVStr:7:3}
       echo "Python Version set to $V"
    fi
    [ -w $CondaPath/lib/python$V ] && echo "Confirmed that $CondaPath/lib/python$V is writeable." ||
	    {
		echo "ERROR: No write permission for $CondaPath/lib/python$V"
		exit 1
	    }
#    cp -R SQ $CondaPath/lib/python3.5
    cp $V/* $CondaPath/lib/python$V
#    cp $V/$CUNCSD_SQ_MODULE $CondaPath/lib/python$V
    [ -w ./lib ] && cp ./lib/* $CondaPath/lib
    echo "**** Successfully installed the cuncsd modules to $CondaPath/lib/python$V ****"
fi












































