A version of the frontend packages as a war file.

The build is manual for now.

Deploy with:

```bash
mvn deploy:deploy-file \
 --batch-mode \
 "-DgroupId=com.octopus" \
 "-DartifactId=java-frontend" \
 "-Dversion=20251030.455.1" \
 "-Dpackaging=war" \
 "-Dfile=/home/matthew/Code/Octopub/java/frontend/target/java-frontend-0.1.0.war" \
 "-DrepositoryId=octopus-sales-public-snapshot" \
 "-Durl=s3://octopus-sales-public-maven-repo/snapshot"
```

Test with:

```bash
docker run -p 8888:8080 -v /home/matthew/Code/Octopub/java/frontend/target/java-frontend-0.1.0.war:/usr/local/tomcat/webapps/java-frontend-0.1.0.war --name my-tomcat-app tomcat:latest
```