#/bin/sh

exec > "${PROJECT_DIR:-$(pwd)}/pretest.log" 2>&1
set -o pipefail
set -e

echo '------ENV START------'
printenv
echo '------ENV STOP------'

echo '------SYSTEM INFO START------'
uname -a
echo '------SYSTEM INFO END------'

if [ "$(uname -m)" = "arm64" ]; then
  PATH="/opt/homebrew/bin:$PATH"
fi

if ! docker info > /dev/null 2>&1; then
  echo "This script uses docker, and it isn't running - please start docker and try again!"
  exit 1
fi

echo "Removing running sonarqube instance..."
docker rm -f sonarqube 2> /dev/null
echo "Starting sonarqube instance..."
docker run -d --name sonarqube -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true -p 9000:9000 sonarqube:latest
while ! { curl --silent --fail -L -u admin:admin "http://localhost:9000/api/system/health" \
          | jq -e '.health == "GREEN"' >/dev/null; }; do
    echo "Waiting for sonarqube to start up. Trying again in 10 seconds."
    sleep 10
done

echo "Sonar has started on http://localhost:9000"
echo "$(curl --silent --fail -L -u admin:admin "http://localhost:9000/api/system/health")"

cd "${PROJECT_DIR:-$(pwd)}/SonariOSUITests/sonar-scanning-examples/sonar-scanner-maven/maven-basic"

sonarToken=$(curl -X POST -L -u admin:admin "http://localhost:9000/api/user_tokens/generate?name=maven-example" | jq -r '.token')

echo "Sonar Token:" $sonarToken

mvn clean verify sonar:sonar -Dsonar.token=$sonarToken
