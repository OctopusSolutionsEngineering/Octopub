This repository is a monorepo containing the source code for multiple applications, including a backend application, a frontend application, and a shared library.

The Java applications are based on the Quarkus framework and are built with Maven.

The Java applications follow a package structure based on Domain Driven Design.

* The interfaces and API definitions are in the `com.octopus.<appname>.application` package.
* The business logic and domain models are in the `com.octopus.<appname>.domain` package.
* Interactions with external systems and infrastructure are in the `com.octopus.<appname>.infrastructure` package.

The frontend application is plain JavaScript and HTML, and is designed to be served as static files from a web server.

The repository contains files for deploying to Kubernetes, Argo CD, building Helm charts, building Docker compose stacks, and deploying to cloud platforms.