FROM alpine:latest as build

RUN apk --no-cache add binutils curl tar gzip

#
# Install JDK
#
RUN curl https://cdn.azul.com/zulu/bin/zulu15.28.13-ca-jdk15.0.1-linux_musl_x64.tar.gz -o /jdk.tar.gz
RUN mkdir -p /jdk
RUN tar xzf /jdk.tar.gz --strip-components=1 -C /jdk
ENV PATH=/jdk/bin:$PATH
ENV JAVA_HOME=/jdk

#
# Build LDS Server
#
RUN ["jlink", "--strip-debug", "--no-header-files", "--no-man-pages", "--compress=2", "--module-path", "/jdk/jmods", "--output", "/linked",\
 "--add-modules", "jdk.unsupported,java.base,java.management,java.net.http,java.xml,java.naming,java.desktop,java.sql,jdk.jcmd,jdk.jartool,jdk.jdi,jdk.jfr"]

#
# Build LDS image
#
FROM alpine:latest as base

RUN apk --no-cache add curl tar gzip nano jq

#
# Resources from build image
#
COPY run.sh /lds/run.sh
COPY --from=build /linked /jdk/
COPY --from=build /jdk/bin/jar /jdk/bin/jcmd /jdk/bin/jdb /jdk/bin/jfr /jdk/bin/jinfo /jdk/bin/jmap /jdk/bin/jps /jdk/bin/jstack /jdk/bin/jstat /linked/bin/
COPY target/dependency /lds/lib/
COPY target/linked-data-store-*.jar /lds/lib/

ENV PATH=/jdk/bin:$PATH

WORKDIR /lds

VOLUME ["/lds/conf", "/lds/schemas"]

EXPOSE 9090

CMD ["./run.sh"]
