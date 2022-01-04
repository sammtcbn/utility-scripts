#!/bin/bash
ME=$(basename $0)

ip=
id=
pw=

read -p "install to remote ssh ip: [localhost] " ip

if [ ! -z "${ip}" ]; then
    read -p "login id: " id
    if [ -z "${id}" ]; then
        exit 1
    fi
    printf "login password: "
    read -s pw
    if [ -z "${pw}" ]; then
        printf "\n"
        exit 1
    fi
    printf "*\n"
fi

if [ -z "${ip}" ]; then
    destpath=~/bin
else
    destpath=/home/${id}/bin
fi

read -p "install path ? [${destpath}] " tmppath

if [ ! -z "${tmppath}" ]; then
    destpath=tmppath
fi

if [ -z "${ip}" ]; then
    read -p "Are you sure you want to install to ${destpath} ? [y/N] " ins
else
    read -p "Are you sure you want to install to ${id}@${ip}:${destpath} ? [y/N] " ins
fi

if [ "${ins}" != "y" ] && [ "${ins}" != "Y" ]; then
    exit 1
fi

src=linux

function cmd_exists ()
{
    if ! type $1> /dev/null 2>&1; then
        return 1
    else
        return 0
    fi
}

function remote_exec ()
{
    if cmd_exists sshpass ; then
        sshpass -p ${pw} ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${id}@${ip} ${@}
    else
        ssh ${id}@${ip} ${@}
    fi
}

function install_to_local ()
{
    mkdir -p ${destpath} || exit 1
    cp -rf ${src}/* ${destpath} || exit 1
}


function install_to_remote ()
{
  remote_exec mkdir -p ${destpath}

  for f in ${src}/*; do
    echo ${f}

    if [[ -d ${f} ]]; then
        if cmd_exists sshpass ; then
            sshpass -p ${pw} scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -r $f ${id}@${ip}:${destpath}
        else
            scp -r $f ${id}@${ip}:${destpath}
        fi
    elif [[ -f ${f} ]]; then
        if cmd_exists sshpass ; then
            sshpass -p ${pw} scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $f ${id}@${ip}:${destpath}
        else
            scp $f ${id}@${ip}:${destpath}
        fi
    else
        echo "$f not found"
    fi
  done

}

if [ -z "${ip}" ]; then
    echo install to ${destpath} ...
    install_to_local
else
    echo install to ${id}@${ip}:${destpath} ...
    install_to_remote
fi

echo "done"
