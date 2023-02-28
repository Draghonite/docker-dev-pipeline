# docker-dev-pipeline

Run Jenkins, SonarQube and JFrog Artifactory in a local environment within Docker.  This is suitable for local development, learning and testing Jenkins pipelines, and is not intended for production workloads.  This assumes prior installation of Docker (Desktop) in your system.

To start:
1. run `sh start.sh` -- runs the installer script, configuring the Docker-in-Docker and Jenkins containers using the Dockerfile and supporting files, including jenkins-plugins
1. run `docker exec jenkins-blueocean cat /var/jenkins_home/secrets/initialAdminPassword` to print the initial admin password
1. in a web browser, bring up `http://localhost:8080` to access your new, local instance of Jenkins and use the initial password to login

To stop and delete the containers and images:
1. run `docker ps`, optional but used to ensure the two running containers for `jenkins-docker` and `jenkins-blueocean`
1. run `docker stop jenkins-docker jenkins-blueocean`, to stop both containers
1. run `docker rm jenkins-blueocean`, to delete the blue-ocean container; note that the other container is automatically deleted as it was configured as such
1. run `docker rmi myjenkins-blueocean:2.375.3 docker:dind`, to delete both images

Note that following this process introduces risk of data-loss and additional steps may be necessary to create a failproof configuration.  Proceed with caution if risk of data-loss is unnacceptable.

To manage the list of pre-installed Jenkins plugins, add or remove from the newline-delimited `jenkins-plugins` file; see the list at [https://plugins.jenkins.io/ui/search].  Follow the appropriate steps earlier to stop (and delete if needed) the Docker containers as appropriate, followed by (re) starting the process.

### Assumptions
This script assumes prior installation of Docker and that docker is running.

### Credits
- https://medium.com/the-devops-ship/custom-jenkins-dockerfile-jenkins-docker-image-with-pre-installed-plugins-default-admin-user-d0107b582577
- https://www.jenkins.io/doc/tutorials/build-a-node-js-and-react-app-with-npm/
- https://issues.jenkins.io/browse/JENKINS-63449?jql=project%20%3D%20JENKINS%20AND%20status%20in%20(Open%2C%20%22In%20Progress%22%2C%20Reopened)%20AND%20component%20%3D%20%27durable-task-plugin%27
- https://www.jfrog.com/confluence/display/RTF4X/Running+with+Docker
