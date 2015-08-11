#!/bin/bash
BASEDIR=$(dirname "$0")

read -r -p "WARNING: Are you sure you want to switch LIVE domain to the actual PREPROD environment? (y/n) " RESPONSE
echo

if [[ $RESPONSE =~ ^[yY]$ ]]; then

gettarget () {
    STARTPATH=`pwd`
    cd $1
    TARGET=`pwd`
    cd ${STARTPATH}
}

if [ ! -L ${BASEDIR}/prod ]; then
  NEW_PROD_TARGET=${BASEDIR}/htdocs1
else
  NEW_PROD_TARGET=`readlink ${BASEDIR}/preprod`
fi


if [ ! -L ${BASEDIR}/prod ]; then
  NEW_PREPROD_TARGET=${BASEDIR}/htdocs2
else
  NEW_PREPROD_TARGET=`readlink ${BASEDIR}/prod`
fi

echo "Before:"
ls -al prod
ls -al preprod

rm "${BASEDIR}/prod"
rm "${BASEDIR}/preprod"

ln -s "${NEW_PROD_TARGET}" "${BASEDIR}/prod"
ln -s "${NEW_PREPROD_TARGET}" "${BASEDIR}/preprod"

echo "After/now:"
ls -al prod
ls -al preprod

fi