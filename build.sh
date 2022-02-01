set -euxo pipefail

docker build -f Dockerfile -t "uvafnwi/latexservice:latest" .
docker push "uvafnwi/latexservice:latest"

docker build -f Dockerfile -t "fnwicr.azurecr.io/latexservice:latest" .
docker push "fnwicr.azurecr.io/latexservice:latest"

VERSION="0.2.2"
helm package --version "${VERSION}" --app-version "${VERSION}" charts/latexservice
helm chart save "latexservice-${VERSION}.tgz" "fnwicr.azurecr.io/helm/latexservice:${VERSION}"
helm chart push "fnwicr.azurecr.io/helm/latexservice:${VERSION}"