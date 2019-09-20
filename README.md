# Linked-data-store server and docker build

## Build and run

### Development
1. Run `./build-dev.sh` to build LDS "development" image (Requires bash, docker, maven, and java). Optinally run 
`./build-dev.sh clean` instead to force delete all persistent volumes and start with a clean environment.
1. Run `$ ./run-dev.sh` to start LDS using the SSB GSIM-based information model.
1. Optionally run `$ ./import-examples.sh` to import the standard examples included with the latest model.

### Production
1. Resolve snapshot dependencies in pom.xml to released versions only.
1. Build docker image using the default dockerfile: `docker build -t statisticsnorway/lds .`
