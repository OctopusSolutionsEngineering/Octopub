This repository is a monorepo containing the source code for multiple applications, including a backend application, a frontend application, and a shared library.

The Java applications are based on the Quarkus framework and are built with Maven.

The Java applications follow a package structure based on Domain Driven Design.

* The interfaces and API definitions are in the `com.octopus.<appname>.application` package.
* The business logic and domain models are in the `com.octopus.<appname>.domain` package.
* Interactions with external systems and infrastructure are in the `com.octopus.<appname>.infrastructure` package.

The frontend application is plain JavaScript and HTML, and is designed to be served as static files from a web server.

The repository contains files for deploying to Kubernetes, Argo CD, building Helm charts, building Docker compose stacks, and deploying to cloud platforms.

## General Guidelines

- Check code for security vulnerabilities
- Flag any use of `innerHTML` without first purifying the result with `DOMPurify.sanitize()` or some other HTML escaping function, as this is a security risk if the content is not properly sanitized.
- Flag any use of `eval()`, as this is a security risk.
- Flag any use of iframes, as they can introduce security risks if not used carefully.
- None of the applications should make external network calls to third party services, except for the frontend application which may make calls to the backend application. If you see any code that makes external network calls, please flag it as a potential security risk.