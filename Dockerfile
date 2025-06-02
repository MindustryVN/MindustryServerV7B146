
FROM gradle:7.6.2-jdk17 AS build
COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src

RUN chmod +x ./gradlew
RUN ./gradlew server:dist --build-cache --stacktrace

FROM eclipse-temurin:17

COPY --from=build /home/gradle/src/server/build/libs/*.jar /app/server.jar

ENTRYPOINT ["java","-XX:ErrorFile=/config/hs_err_pid%p.log","-XX:+HeapDumpOnOutOfMemoryError", "-XX:HeapDumpPath=/config/heap.hprof", "-XX:+PrintGCDetails","-XX:+PrintGCDateStamps","-Xloggc:/config/gc.log", "-XX:NativeMemoryTracking=summary", "-XX:+UnlockDiagnosticVMOptions" ,"-jar", "/app/server.jar"]



