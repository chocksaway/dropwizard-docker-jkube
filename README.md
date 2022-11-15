## Dropwizard Java Example

This is an example Dropwizard app using Java. 

## Running The App 
Ensure you have Java 8 or later.
```
./generate-keystore.sh
mvn clean package
java -jar target/dropwizard-docker-jkube.jar server 
```

## Deploying the app using jkube -> kubernetes

Building docker image:
```
$ mvn package k8s:build

[snip]

[INFO] --- kubernetes-maven-plugin:1.10.0:build (default-cli) @ dropwizard-docker-jkube ---
[INFO] k8s: Building Docker image in Kubernetes mode
[INFO] k8s: Using Dockerfile: /home/milesd/workspace/dropwizard-docker-jkube/Dockerfile
[INFO] k8s: Using Docker Context Directory: /home/milesd/workspace/dropwizard-docker-jkube
[INFO] k8s: [docker.io/chocksaway/dropwizard-docker-jkube:latest]: Created docker-build.tar in 144 milliseconds
[INFO] k8s: [docker.io/chocksaway/dropwizard-docker-jkube:latest]: Built image sha256:157f0
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  6.750 s
[INFO] Finished at: 2022-11-15T17:58:37Z
```

List docker images:
```
$ docker images
REPOSITORY                                   TAG                  IMAGE ID       CREATED             SIZE
chocksaway/dropwizard-docker-jkube           latest               b838b44d27b9   10 minutes ago      438MB
```



Login into docker hub (or equivalent):
```
docker login
```

Push docker image:
```
$ docker push chocksaway/dropwizard-docker-jkube:latest
The push refers to repository [docker.io/chocksaway/dropwizard-docker-jkube]
b0ddc0dba107: Pushed 
83a46287b450: Pushed 
05a66a62d154: Pushed 
697bf0c6d15e: Pushed 
276a07e9d4e7: Pushed 
05ccff4e0d22: Pushed 
3c7c9248454d: Pushed 
d2cd905c205e: Pushed 
2110602b3735: Pushed 
bb363ff790df: Pushed 
dc10ed5dc4e8: Layer already exists 
491cc2011e51: Layer already exists 
0ad3ddf4a4ce: Layer already exists 
latest: digest: sha256:8808f589070c2bcb75a019577cc94b81aaaa size: 3035
```

Deploy to Kubernetes:
```
$ mvn k8s:resource k8s:apply
[INFO] Scanning for projects...
[INFO] 
[INFO] ---------------< com.chocksaway:dropwizard-docker-jkube >---------------
[INFO] Building dropwizard-docker-jkube 1.0-SNAPSHOT
[INFO] --------------------------------[ jar ]---------------------------------
[INFO] 
[INFO] --- kubernetes-maven-plugin:1.10.0:resource (default-cli) @ dropwizard-docker-jkube ---
[INFO] k8s: Using Dockerfile: /home/milesd/workspace/dropwizard-docker-jkube/Dockerfile
[INFO] k8s: Using Docker Context Directory: /home/milesd/workspace/dropwizard-docker-jkube
[INFO] k8s: Using resource templates from /home/milesd/workspace/dropwizard-docker-jkube/src/main/jkube
[INFO] k8s: jkube-controller: Adding a default Deployment
[INFO] k8s: jkube-service: Adding a default service 'dropwizard-docker-jkube' with ports [8443]
[INFO] k8s: jkube-service-discovery: Using first mentioned service port '8443' 
[INFO] k8s: jkube-revision-history: Adding revision history limit to 2
[INFO] k8s: validating /home/milesd/workspace/dropwizard-docker-jkube/target/classes/META-INF/jkube/kubernetes/dropwizard-docker-jkube-deployment.yml resource
[WARNING] Unknown keyword $module - you should define your own Meta Schema. If the keyword is irrelevant for validation, just use a NonValidationKeyword
[WARNING] Unknown keyword existingJavaType - you should define your own Meta Schema. If the keyword is irrelevant for validation, just use a NonValidationKeyword
[WARNING] Unknown keyword javaOmitEmpty - you should define your own Meta Schema. If the keyword is irrelevant for validation, just use a NonValidationKeyword
[INFO] k8s: validating /home/milesd/workspace/dropwizard-docker-jkube/target/classes/META-INF/jkube/kubernetes/dropwizard-docker-jkube-service.yml resource
[INFO] 
[INFO] --- kubernetes-maven-plugin:1.10.0:apply (default-cli) @ dropwizard-docker-jkube ---
[INFO] k8s: Using Kubernetes at https://xxx.xxx.xxx.xxx:8443/ in namespace null with manifest /home/milesd/workspace/dropwizard-docker-jkube/target/classes/META-INF/jkube/kubernetes.yml 
[INFO] k8s: Updating Service from kubernetes.yml
[INFO] k8s: Updated Service: target/jkube/applyJson/default/service-dropwizard-docker-jkube-2.json
[INFO] k8s: Updating Deployment from kubernetes.yml
[INFO] k8s: Updated Deployment: target/jkube/applyJson/default/deployment-dropwizard-docker-jkube-2.json
[INFO] k8s: HINT: Use the command `kubectl get pods -w` to watch your pods start up
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  2.711 s
[INFO] Finished at: 2022-11-15T18:03:04Z
[INFO] ------------------------------------------------------------------------
```

Check running pods:
```
$ kubectl get pods
NAME                                      READY   STATUS    RESTARTS   AGE
docker-file-simple-74ccd899f6-hc654       1/1     Running   0          131m
dropwizard-docker-jkube-c7cf8659c-982cb   1/1     Running   0          107s
dropwizard-java-example-785bd6f74-mfkbf   1/1     Running   0          79m
```

Check start-up logs:
```
$ kubectl logs dropwizard-docker-jkube-c7cf8659c-982cb
INFO  [2022-11-15 18:02:42,560] org.eclipse.jetty.util.log: Logging initialized @607ms to org.eclipse.jetty.util.log.Slf4jLog
INFO  [2022-11-15 18:02:42,587] io.dropwizard.server.DefaultServerFactory: Registering jersey handler with root path prefix: /
INFO  [2022-11-15 18:02:42,587] io.dropwizard.server.DefaultServerFactory: Registering admin handler with root path prefix: /
INFO  [2022-11-15 18:02:42,611] io.dropwizard.server.ServerFactory: Starting App
.___                           .__                         .___
__| _/______  ____ ________  _  _|__|____________ _______  __| _/
/ __ |\_  __ \/  _ \\____ \ \/ \/ /  \___   /\__  \\_  __ \/ __ |
/ /_/ | |  | \(  <_> )  |_> >     /|  |/    /  / __ \|  | \/ /_/ |
\____ | |__|   \____/|   __/ \/\_/ |__/_____ \(____  /__|  \____ |
\/              |__|                   \/     \/           \/
INFO  [2022-11-15 18:02:42,671] org.eclipse.jetty.setuid.SetUIDListener: Opened application@4dbad37{HTTP/1.1, (http/1.1)}{0.0.0.0:8080}
INFO  [2022-11-15 18:02:42,671] org.eclipse.jetty.setuid.SetUIDListener: Opened application@7b4acdc2{SSL, (ssl, http/1.1)}{0.0.0.0:8443}
INFO  [2022-11-15 18:02:42,671] org.eclipse.jetty.setuid.SetUIDListener: Opened admin@26a262d6{HTTP/1.1, (http/1.1)}{0.0.0.0:8081}
INFO  [2022-11-15 18:02:42,672] org.eclipse.jetty.server.Server: jetty-9.4.49.v20220914; built: 2022-09-14T01:07:36.601Z; git: 4231a3b2e4cb8548a412a789936d640a97b1aa0a; jvm 17.0.2+8-86
INFO  [2022-11-15 18:02:42,794] org.eclipse.jetty.util.ssl.SslContextFactory: x509=X509@249e0271(dropwizard-java-example,h=[dropwizard-docker-jkube],a=[],w=[]) for Server@4893b344[provider=null,keyStore=file:///app/keystore.pfx,trustStore=null]
INFO  [2022-11-15 18:02:42,840] io.dropwizard.jetty.HttpsConnectorFactory: Enabled protocols: [TLSv1.2]
INFO  [2022-11-15 18:02:42,840] io.dropwizard.jetty.HttpsConnectorFactory: Disabled protocols: [SSLv2Hello, SSLv3, TLSv1, TLSv1.1, TLSv1.3]
INFO  [2022-11-15 18:02:42,840] io.dropwizard.jetty.HttpsConnectorFactory: Enabled cipher suites: [TLS_AES_128_GCM_SHA256, TLS_AES_256_GCM_SHA384, TLS_CHACHA20_POLY1305_SHA256, TLS_DHE_DSS_WITH_AES_128_CBC_SHA256, TLS_DHE_DSS_WITH_AES_128_GCM_SHA256, TLS_DHE_DSS_WITH_AES_256_CBC_SHA256, TLS_DHE_DSS_WITH_AES_256_GCM_SHA384, TLS_DHE_RSA_WITH_AES_128_CBC_SHA256, TLS_DHE_RSA_WITH_AES_128_GCM_SHA256, TLS_DHE_RSA_WITH_AES_256_CBC_SHA256, TLS_DHE_RSA_WITH_AES_256_GCM_SHA384, TLS_DHE_RSA_WITH_CHACHA20_POLY1305_SHA256, TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256, TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256, TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384, TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384, TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256, TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256, TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256, TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384, TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384, TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256, TLS_ECDH_ECDSA_WITH_AES_128_CBC_SHA256, TLS_ECDH_ECDSA_WITH_AES_128_GCM_SHA256, TLS_ECDH_ECDSA_WITH_AES_256_CBC_SHA384, TLS_ECDH_ECDSA_WITH_AES_256_GCM_SHA384, TLS_ECDH_RSA_WITH_AES_128_CBC_SHA256, TLS_ECDH_RSA_WITH_AES_128_GCM_SHA256, TLS_ECDH_RSA_WITH_AES_256_CBC_SHA384, TLS_ECDH_RSA_WITH_AES_256_GCM_SHA384, TLS_EMPTY_RENEGOTIATION_INFO_SCSV]
INFO  [2022-11-15 18:02:42,840] io.dropwizard.jetty.HttpsConnectorFactory: Disabled cipher suites: [TLS_DHE_DSS_WITH_AES_128_CBC_SHA, TLS_DHE_DSS_WITH_AES_256_CBC_SHA, TLS_DHE_RSA_WITH_AES_128_CBC_SHA, TLS_DHE_RSA_WITH_AES_256_CBC_SHA, TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA, TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA, TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA, TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA, TLS_ECDH_ECDSA_WITH_AES_128_CBC_SHA, TLS_ECDH_ECDSA_WITH_AES_256_CBC_SHA, TLS_ECDH_RSA_WITH_AES_128_CBC_SHA, TLS_ECDH_RSA_WITH_AES_256_CBC_SHA, TLS_RSA_WITH_AES_128_CBC_SHA, TLS_RSA_WITH_AES_128_CBC_SHA256, TLS_RSA_WITH_AES_128_GCM_SHA256, TLS_RSA_WITH_AES_256_CBC_SHA, TLS_RSA_WITH_AES_256_CBC_SHA256, TLS_RSA_WITH_AES_256_GCM_SHA384]

INFO  [2022-11-15 18:02:43,006] io.dropwizard.jersey.DropwizardResourceConfig: The following paths were found for the configured resources:

    GET     / (com.chocksaway.controller.RootResource)

INFO  [2022-11-15 18:02:43,007] org.eclipse.jetty.server.handler.ContextHandler: Started i.d.j.MutableServletContextHandler@4c1d59cd{/,null,AVAILABLE}
INFO  [2022-11-15 18:02:43,008] io.dropwizard.setup.AdminEnvironment: tasks =

    POST    /tasks/log-level (io.dropwizard.servlets.tasks.LogConfigurationTask)
    POST    /tasks/gc (io.dropwizard.servlets.tasks.GarbageCollectionTask)

INFO  [2022-11-15 18:02:43,009] org.eclipse.jetty.server.handler.ContextHandler: Started i.d.j.MutableServletContextHandler@65e22def{/,null,AVAILABLE}
INFO  [2022-11-15 18:02:43,012] org.eclipse.jetty.server.AbstractConnector: Started application@4dbad37{HTTP/1.1, (http/1.1)}{0.0.0.0:8080}
INFO  [2022-11-15 18:02:43,012] org.eclipse.jetty.server.AbstractConnector: Started application@7b4acdc2{SSL, (ssl, http/1.1)}{0.0.0.0:8443}
INFO  [2022-11-15 18:02:43,012] org.eclipse.jetty.server.AbstractConnector: Started admin@26a262d6{HTTP/1.1, (http/1.1)}{0.0.0.0:8081}
INFO  [2022-11-15 18:02:43,012] org.eclipse.jetty.server.Server: Started @1060ms
```

Reference:

kubectl get pods

kubectl delete pod pod-name

kubectl logs pod-name

kubectl get pod -o wide



## Running The App Using Docker
Ensure you have a working Docker environment.
```
make dist image run
```

## Testing The Endpoints
Point your browser to `http://localhost:8080` or use `curl` in command line.

```
curl -v  http://localhost:8080/
curl -v -k https://localhost:8443/
```
Operational menu endpoint:
* `http://localhost:8081`


