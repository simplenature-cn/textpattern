# Use TextPattern with Docker and K8S

## Build Docker image

`docker build -t textpattern . `

then you can run the docker image and access it by http://localhost

`docker run -p 80:80 textpattern:latest`

then you can visit http://localhost/textpattern/setup/ to setup the textpattern.

alternatly , we can remove the setup pages and add default config about mysql etc.

## deploy with nas pv to k8s
```
kubectl apply -f txp.yml
kubectl apply -f txp-nas.yml
dep.sh Stage
```

### remaind issue
* the mount path(images/files etc) does not have writable permission. this is a issue of owner. we can not use root. we may need help of cggroup 

* the mysql setting is included in code.(for now, that is OK)
