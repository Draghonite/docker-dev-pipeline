# credits: https://www.jenkins.io/doc/tutorials/build-a-node-js-and-react-app-with-npm/

docker network create jenkins

docker run \
    --name jenkins-docker \
    --rm \
    --detach \
    --privileged \
    --network jenkins \
    --network-alias docker \
    --env DOCKER_TLS_CERTDIR=/certs \
    --volume jenkins-docker-certs:/certs/client \
    --volume jenkins-data:/var/jenkins_home \
    --publish 2376:2376 \
    docker:dind \
    --storage-driver overlay2 

docker build -t myjenkins-blueocean:2.375.3 .

docker run \
    --name jenkins-blueocean \
    --detach \
    --network jenkins \
    --env DOCKER_HOST=tcp://docker:2376 \
    --env DOCKER_CERT_PATH=/certs/client \
    --env DOCKER_TLS_VERIFY=1 \
    --publish 8080:8080 \
    --publish 50000:50000 \
    --volume jenkins-data:/var/jenkins_home \
    --volume jenkins-docker-certs:/certs/client:ro \
    --restart=on-failure \
    --env JAVA_OPTS="-Dhudson.plugins.git.GitSCM.ALLOW_LOCAL_CHECKOUT=true" \
    myjenkins-blueocean:2.375.3 

docker run -d --name sonarqube --network jenkins -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true -p 9000:9000 sonarqube:latest

docker run -d --name artifactory --network jenkins -p 8081:8081 jfrog-docker-reg2.bintray.io/jfrog/artifactory-oss:4.1.0
