#!/bin/bash

BASEDIR=$(dirname "$0")
DRUPAL_ROOT="${BASEDIR}/../../drupal"

cd ${DRUPAL_ROOT} && drush bam-backup