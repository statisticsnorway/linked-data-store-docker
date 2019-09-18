FROM statisticsnorway/lds-server-base:latest as build

#
# Build LDS Server
#
RUN ["jlink", "--strip-debug", "--no-header-files", "--no-man-pages", "--compress=2", "--module-path", "/opt/jdk/jmods", "--output", "/linked",\
 "--add-modules", "jdk.unsupported,java.base,java.management,java.net.http,java.xml,java.naming,java.desktop,java.sql"]
COPY pom.xml /lds/
WORKDIR /lds
RUN mvn -B verify dependency:go-offline
COPY src /lds/src/
RUN mvn -B -o verify && mvn -B -o dependency:copy-dependencies

#
# Build LDS image
#
FROM alpine:latest

#
# Resources from build image
#
COPY --from=build /linked /jdk/
COPY --from=build /lds/target/dependency /lds/lib/
COPY --from=build /lds/target/linked-data-store-*.jar /lds/lib/

ENV PATH=/jdk/bin:$PATH

WORKDIR /lds

VOLUME ["/lds/conf", "/lds/schemas"]

EXPOSE 9090

CMD ["java", "-p", "/lds/lib", "-m", "no.ssb.lds.server/no.ssb.lds.server.Server"]
