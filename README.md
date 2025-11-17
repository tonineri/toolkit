<div align="center">

![SAS Viya](/docs/images/sas-viya.png)

# **Toolkit Pod**

[![License: MIT](https://img.shields.io/badge/license-MIT-yellow.svg)](LICENSE.md)
[![Build Status](https://github.com/tonineri/toolkit/actions/workflows/build.yaml/badge.svg)](https://github.com/tonineri/toolkit/actions/workflows/build.yaml)
[![Security Scanning](https://img.shields.io/badge/security-scanned-brightgreen)](https://github.com/tonineri/toolkit/security/code-scanning)
[![ghcr.io](https://img.shields.io/badge/ghcr.io-toolkit-blue?logo=docker)](https://github.com/tonineri/toolkit/pkgs/container/toolkit)
[![Maintained](https://img.shields.io/badge/maintained%3F-yes-green.svg)](https://github.com/tonineri/toolkit/graphs/commit-activity)
[![Red Hat UBI9](https://img.shields.io/badge/base-UBI9_minimal-red)](https://catalog.redhat.com/software/containers/ubi9/ubi-minimal/615bd9b4075b022acc111bf5)

</div>

![divider](/docs/images/divider.png)

## Description

A pod based on the latest **Red Hat Universal Base Image 9 (Minimal)** `ubi9-minimal:latest` which provides essential tools to troubleshoot containerized SAS Viya environments.

![divider](/docs/images/divider.png)

## Prerequisites

Before using the `toolkit` pod, ensure you have **pod deployment capabilities within the specified namespace(s)**.

![divider](/docs/images/divider.png)

## Usage

To get started with the `toolkit`, follow these steps:

- Keeping defaults:

    ```sh
    kubectl -n <namespace> apply -f https://raw.githubusercontent.com/tonineri/toolkit/main/pod-toolkit.yaml
    kubectl -n <namespace> exec -it toolkit -- zsh
    ```

- Customize the [`pod-toolkit.yaml`](pod-toolkit.yaml) file before deploying the pod:

    1. Get the latest version of the manifest:

    ```sh
    wget https://raw.githubusercontent.com/tonineri/toolkit/main/pod-toolkit.yaml
    ```

    2. Edit the `pod-toolkit.yaml` and deploy the pod in your namespace:

    ```sh
    vi pod-toolkit.yaml
    # Make your modifications
    kubectl -n <namespace> apply -f pod-toolkit.yaml
    ```

    3. Access the pod:

    ```sh
    kubectl -n <namespace> exec -it toolkit -- zsh
    ```

![divider](/docs/images/divider.png)

## Contributing

We welcome contributions. Please submit your ideas, bug reports, or feature requests via the [issue tracker](https://github.com/tonineri/toolkit/issues).

![divider](/docs/images/divider.png)

## License

This project is licensed under the [MIT License](LICENSE.md).

![divider](/docs/images/divider.png)
