#!/bin/bash
set -e # permet au script de s'arreter à la 1ere erreur

COVERAGE_FOLDER="${CI_COVERAGE_FOLDER:-build/test-results/test/}"
TEST_FOLDER="${CI_TEST_FOLDER:-test-results}"


# supprime le dossier build
./gradlew clean build

if [ $? -ne 0 ]; then
  echo "Erreur Lors du build"
  exit 1
fi

./gradlew -q  test

if [ $? -ne 0 ]; then
  echo "Erreur Lors des tests"
  exit 1
fi

rm -rf $TEST_FOLDER
mv -f $COVERAGE_FOLDER $TEST_FOLDER

if [ "$(ls -Uba1 "$TEST_FOLDER" | grep 'xml$' | wc -l)" -eq 0 ]; then
  echo "$TEST_FOLDER/"*.xml
  echo "Erreur Lors de la récupération du rapport"
  exit 1
fi

