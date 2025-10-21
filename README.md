<div align="center">

![SAS Viya](/.design/sas-viya.png)

# **Toolkit Pod**

[![License](https://img.shields.io/badge/license-MIT-blue)](LICENSE.md)

</div>

![divider](https://i.ibb.co/Rk1CXDML/divider.png)

## Description

A pod based on the latest **Red Hat Universal Base Image 9 (Minimal)** `ubi9-minimal:latest` which provides essential tools to troubleshoot containerized SAS Viya environments.

![divider](https://i.ibb.co/Rk1CXDML/divider.png)

## Prerequisites

Before using the `toolkit` pod, ensure you have **pod deployment capabilities within the specified namespace(s)**.

![divider](https://i.ibb.co/Rk1CXDML/divider.png)

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

![divider](https://i.ibb.co/Rk1CXDML/divider.png)

## Contributing

We welcome contributions. Please submit your ideas, bug reports, or feature requests via the [issue tracker](https://github.com/tonineri/toolkit/issues).

![divider](https://i.ibb.co/Rk1CXDML/divider.png)

## License

This project is licensed under the [MIT License](LICENSE.md).

![divider](https://i.ibb.co/Rk1CXDML/divider.png)
