#/bin/sh

exec > "${PROJECT_DIR:-$(pwd)}/posttest.log" 2>&1
set -o pipefail
set -e
echo "Removing running sonarqube instance..."
docker rm -f sonarqube 2> /dev/null
