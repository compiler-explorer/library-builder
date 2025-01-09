# Library-builder

Docker image for building CE libraries

Requirements:

* AWS credentials or running in AWS environment with the correct access rights.

Usage is described in https://github.com/compiler-explorer/infra/blob/main/admin-daily-builds.sh

## Testing

sudo docker build -t libbuild .
sudo docker run -v/opt:/opt:ro -e "CONAN_PASSWORD=$(aws ssm get-parameter --name /compiler-explorer/conanpwd | jq -r .Parameter.Value)" libbuild bash build.sh "c++" "fmt 11.0.0"
