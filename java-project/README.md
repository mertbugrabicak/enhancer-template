# Example Enhancer

The Example Enhancer is a dedicated enhancer within the SBOMer NextGen architecture.

## Getting Started (Local Development)

This component is designed to run alongside the wider SBOMer system using Helm.

### 1. Start the Infrastructure

Run the local dev from the root of the project repository to set up the minikube environment:

```shell script
bash ./hack/setup-local-dev.sh
```

Then run the command below to start the Helm chart with the component build:

```bash
bash ./hack/run-helm-with-local-build.sh
```