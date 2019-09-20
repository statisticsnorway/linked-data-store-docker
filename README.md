# Linked-data-store server and docker build

## Build and run


### Development

1. Run `./build-dev.sh` to build LDS "development" image (Requires bash, docker, maven, and java). Optionally run 
`./build-dev.sh clean` instead to force delete all persistent volumes and start with a clean environment.

1. Run `$ ./run-dev.sh` to start LDS using the SSB GSIM-based information model.

1. Optionally run `$ ./import-examples.sh` to import the standard examples included with the latest model.

1. Optionally run and debug the LDS java application from you IDE by starting the Server class included in this source 
folder. That instance will be reachable at http://localhost:9190/

1. Optionally open lds-browser at: http://localhost:8000/ Ensure that "LDS location" (under LDS client link in upper 
left corner) is set to "LDS A" which actually points to `http://localhost:9090` being the LDS running in docker-compose. 
It's possible to write an url here directly, e.g. `http://localhost:9190` if you want to connect to LDS server running 
in IDE.

1. Optionally open neo4j-console at: http://localhost:7474/browser/ 

1. Optionally connect to postgres tx-log at: `jdbc:postgresql://localhost:5432/txlog` 

1. Optionally connect to postgres saga-log at: `jdbc:postgresql://localhost:5432/sagalog` 


### Production

1. Resolve snapshot dependencies in pom.xml to released versions only.

1. Build docker image using the default dockerfile: `docker build -t lds .`
