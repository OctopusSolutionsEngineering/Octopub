Octopub is a sample application designed to be deployed to a variety of platforms such as AWS Lambda, Kubernetes, and
static web hosting. It also builds a number of test worker images, test scripts, and security packages.

## Maven feed

A number of packages including SBOM packages and Lambda artifacts, are pushed to a public Maven repo hosted at
https://octopus-sales-public-maven-repo.s3.ap-southeast-2.amazonaws.com/snapshot.

* `com.octopus:octopub-frontend` - The static frontend website
* `com.octopus:octopub-frontend-sbom` - The static frontend website SBOM
* `com.octopus:products-microservice-lambda` - The product microservice native AWS Lambda (requires an external MySQL database)
* `com.octopus:products-microservice-lambda-jvm` - The product microservice JVM AWS Lambda with built in H2 database
* `com.octopus:products-microservice-azurefunction-jvm` - The product microservice JVM Azure Function with built in H2 database
* `com.octopus:products-microservice-awssam` - The product microservice SAM templates (`sam.jvm.yaml` and `sam.native.yaml`)
* `com.octopus:products-microservice-gcf-jar` - The product microservice Google Cloud Function artifact
* `com.octopus:products-microservice-windows` - The product microservice as a Windows executable
* `com.octopus:products-microservice-jar` - The product microservice uber jar
* `com.octopus:products-microservice-systemd` - The product microservice systemd service file
* `com.octopus:products-microservice-mysql-jar` - The product microservice uber jar with MySQL
* `com.octopus:products-microservice-liquidbase` - The product microservice Liquidbase database migration scripts. The changelog file is called `product-changeLog.xml`.
* `com.octopus:products-microservice-sbom` - The product microservice SBOM
* `com.octopus:audit-microservice-lambda` - The audit microservice native AWS Lambda (requires an external MySQL database)
* `com.octopus:audit-microservice-lambda-jvm` - The audit microservice JVM AWS Lambda with built in H2 database
* `com.octopus:audit-microservice-azurefunction-jvm` - The audit microservice JVM Azure Function with built in H2 database
* `com.octopus:audit-microservice-awssam` - The audit microservice SAM templates (`sam.jvm.yaml` and `sam.native.yaml`)
* `com.octopus:audit-microservice-jar` - The audit microservice uber jar
* `com.octopus:audit-microservice-systemd` - The audit microservice systemd service file
* `com.octopus:audit-microservice-mysql-jar` - The audit microservice uber jar with MySQL
* `com.octopus:audit-microservice-liquidbase` - The audit microservice Liquidbase database migration scripts. The changelog file is called `audit-changeLog.xml`.
* `com.octopus:audit-microservice-sbom` - The audit microservice SBOM

## AWS Lambda Entry Points

The JVM Lambda functions used a handler of `io.quarkus.amazon.lambda.runtime.QuarkusStreamHandler::handleRequest`.

The native Lambda functions use a handler of `not.used.in.provided.runtime`.

See the [Quarkus documentation](https://quarkus.io/guides/aws-lambda) for more information.

## AWS Lambda Test

The following test event is used to call the health check endpoint. It is based on the API Gateway proxy event. This JSON can be copied and pasted into the AWS Lambda test event console:

```json
{
  "body": "eyJ0ZXN0IjoiYm9keSJ9",
  "resource": "/{proxy+}",
  "path": "/health/products/GET",
  "httpMethod": "GET",
  "isBase64Encoded": true,
  "queryStringParameters": {
    "foo": "bar"
  },
  "multiValueQueryStringParameters": {
    "foo": [
      "bar"
    ]
  },
  "pathParameters": {
    "proxy": "/health/products/GET"
  },
  "stageVariables": {
    "baz": "qux"
  },
  "headers": {
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
    "Accept-Encoding": "gzip, deflate, sdch",
    "Accept-Language": "en-US,en;q=0.8",
    "Cache-Control": "max-age=0",
    "CloudFront-Forwarded-Proto": "https",
    "CloudFront-Is-Desktop-Viewer": "true",
    "CloudFront-Is-Mobile-Viewer": "false",
    "CloudFront-Is-SmartTV-Viewer": "false",
    "CloudFront-Is-Tablet-Viewer": "false",
    "CloudFront-Viewer-Country": "US",
    "Host": "1234567890.execute-api.us-east-1.amazonaws.com",
    "Upgrade-Insecure-Requests": "1",
    "User-Agent": "Custom User Agent String",
    "Via": "1.1 08f323deadbeefa7af34d5feb414ce27.cloudfront.net (CloudFront)",
    "X-Amz-Cf-Id": "cDehVQoZnx43VYQb9j2-nvCh-9z396Uhbp027Y2JvkCPNLmGJHqlaA==",
    "X-Forwarded-For": "127.0.0.1, 127.0.0.2",
    "X-Forwarded-Port": "443",
    "X-Forwarded-Proto": "https"
  },
  "multiValueHeaders": {
    "Accept": [
      "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
    ],
    "Accept-Encoding": [
      "gzip, deflate, sdch"
    ],
    "Accept-Language": [
      "en-US,en;q=0.8"
    ],
    "Cache-Control": [
      "max-age=0"
    ],
    "CloudFront-Forwarded-Proto": [
      "https"
    ],
    "CloudFront-Is-Desktop-Viewer": [
      "true"
    ],
    "CloudFront-Is-Mobile-Viewer": [
      "false"
    ],
    "CloudFront-Is-SmartTV-Viewer": [
      "false"
    ],
    "CloudFront-Is-Tablet-Viewer": [
      "false"
    ],
    "CloudFront-Viewer-Country": [
      "US"
    ],
    "Host": [
      "0123456789.execute-api.us-east-1.amazonaws.com"
    ],
    "Upgrade-Insecure-Requests": [
      "1"
    ],
    "User-Agent": [
      "Custom User Agent String"
    ],
    "Via": [
      "1.1 08f323deadbeefa7af34d5feb414ce27.cloudfront.net (CloudFront)"
    ],
    "X-Amz-Cf-Id": [
      "cDehVQoZnx43VYQb9j2-nvCh-9z396Uhbp027Y2JvkCPNLmGJHqlaA=="
    ],
    "X-Forwarded-For": [
      "127.0.0.1, 127.0.0.2"
    ],
    "X-Forwarded-Port": [
      "443"
    ],
    "X-Forwarded-Proto": [
      "https"
    ]
  },
  "requestContext": {
    "accountId": "123456789012",
    "resourceId": "123456",
    "stage": "prod",
    "requestId": "c6af9ac6-7b61-11e6-9a41-93e8deadbeef",
    "requestTime": "09/Apr/2015:12:34:56 +0000",
    "requestTimeEpoch": 1428582896000,
    "identity": {
      "cognitoIdentityPoolId": null,
      "accountId": null,
      "cognitoIdentityId": null,
      "caller": null,
      "accessKey": null,
      "sourceIp": "127.0.0.1",
      "cognitoAuthenticationType": null,
      "cognitoAuthenticationProvider": null,
      "userArn": null,
      "userAgent": "Custom User Agent String",
      "user": null
    },
    "path": "/health/products/GET",
    "resourcePath": "/{proxy+}",
    "httpMethod": "POST",
    "apiId": "1234567890",
    "protocol": "HTTP/1.1"
  }
}
```

## Downloading files locally

You can download Zip Maven artifacts locally with a command like:

```
mvn org.apache.maven.plugins:maven-dependency-plugin:3.6.0:get "-DremoteRepositories=https://octopus-sales-public-maven-repo.s3.ap-southeast-2.amazonaws.com/snapshot/" -Dartifact=com.octopus:products-microservice-lambda:LATEST:zip
```

Jar files are downloaded with a command like:

```
mvn org.apache.maven.plugins:maven-dependency-plugin:3.6.0:get "-DremoteRepositories=https://octopus-sales-public-maven-repo.s3.ap-southeast-2.amazonaws.com/snapshot/" -Dartifact=com.octopus:products-microservice-gcf-jar:LATEST:jar
```


Replace `com.octopus:products-microservice-lambda` with the artifact ID listed in the previous section.

## Docker images

The following images are built:

| Image                                              | Description                                                               | Port  | User ID | Group ID | Filesystem Write Access Required |
|----------------------------------------------------|---------------------------------------------------------------------------|-------|---------|----------|----------------------------------|
| octopussamples/octopub-products-microservice       | The backend products service with embedded database                       | 8083  | 1001    | 1001     | true                             |
| octopussamples/octopub-products-microservice-mysql | The backend products service configured to use an external MySQL database | 8083  | 1001    | 1001     | true                             |
| octopussamples/octopub-audit-microservice          | The backend audits service with embedded database                         | 10000 | 1001    | 1001     | true                             |
| octopussamples/octopub-audit-microservice-mysql    | The backend audits service configured to use an external MySQL database   | 10000 | 1001    | 1001     | true                             |
| octopussamples/octopub-frontend                    | The frontend web UI                                                       | 8080  | 101     | 101      | true                             |
| octopussamples/octopub-selfcontained               | A self contained image with the frontend and backend services             | 8080  | 101     | 101      | true                             |
| octopussamples/postman-worker-image                | A worker image that includes Postman                                      |       |         |          |                                  |
| octopussamples/cypress-worker-image                | A worker image that includes Cypress                                      |       |         |          |                                  |

## Helm charts

A number of helm charts are saved to the public Helm repo at
https://octopus-sales-public-helm-repo.s3.ap-southeast-2.amazonaws.com/charts:

* `octopub-products-mysql` - Deploys the products microservice with support for a MySQL database.
* `octopub-audits-mysql` - Deploys the audits microservice with support for a MySQL database.
* `octopub-frontend` - Deploys the frontend.

Install these charts locally with the following commands:

```bash
helm repo add SolutionEngineering https://octopus-sales-public-helm-repo.s3.ap-southeast-2.amazonaws.com/charts
helm upgrade -i octopubdb oci://registry-1.docker.io/bitnamicharts/mysql
helm upgrade -i --set database.hostname=octopubdb-mysql --set database.password=$(kubectl get secret --namespace default octopubdb-mysql -o jsonpath="{.data.mysql-root-password}" | base64 -d) octopusprod SolutionEngineering/octopub-products-mysql
helm upgrade -i \
  --set productEndpointOverride=http://$(kubectl get services octopusprod-octopub-products-mysql -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")/api/products \
  octopusweb SolutionEngineering/octopub-frontend
```

## Local testing

To test Octopub locally, use the supplied Docker Compose file:

```bash
cd compose
docker-compose up
```

You can then access the page at http://localhost:5001.

## Database migration examples

If you wish to demonstrate a database migration using the `com.octopus:products-microservice-liquidbase` or 
`com.octopus:audit-microservice-liquidbase` packages, the script below provdes an example with the Liquibase
docker image:

```bash
echo "##octopus[stdout-verbose]"
docker pull liquibase/liquibase
echo "##octopus[stdout-default]"

cd products-microservice-liquidbase

docker run -e INSTALL_MYSQL=true --rm -v ${PWD}:/liquibase/changelog liquibase/liquibase \
  "--changeLogFile=product-changeLog.xml" \
  "--username=#{Database.Username}" \
  "--password=#{Database.Password}" \
  "--url=jdbc:mysql://#{Database.Hostname}:3306/product?createDatabaseIfNotExist=true" \
  update
```

## Configuration Options

### Frontend App

The configuration of the frontend web app is done by modifying the `config.json` file. This can be done two ways:

1. Modify the JSON directly when the static web app is uploaded directly to a hosting platform
2. Configure the Docker image to modify the JSON when the container is started

Option 2 is achieved using the [Ultimate Docker Launcher](https://github.com/mcasperson/UltimateDockerLauncher) (UDL), which
is baked into the Docker images. UDL modifies data files, like config files, based on environment variables. A common
set of environment variables is:

* `UDL_SKIPEMPTY_SETVALUE_1` = `[/usr/share/nginx/html/config.json][productEndpoint]/#{ProductsMicroserviceBaseUrl}/api/products`
* `UDL_SKIPEMPTY_SETVALUE_2` = `[/usr/share/nginx/html/config.json][productHealthEndpoint]/#{ProductsMicroserviceBaseUrl}/health/products`
* `UDL_SKIPEMPTY_SETVALUE_3` = `[/usr/share/nginx/html/config.json][auditEndpoint]/#{ProductsMicroserviceBaseUrl}/api/audits`
* `UDL_SKIPEMPTY_SETVALUE_4` = `[/usr/share/nginx/html/config.json][auditHealthEndpoint]/#{ProductsMicroserviceBaseUrl}/health/audits`
