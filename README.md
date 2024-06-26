<div align="center">

![SAS Viya](/.assets/sasviya.png)

# **Toolkit Pod**

[![License](https://img.shields.io/badge/license-Apache%202.0-blue)](LICENSE.md)

</div>

![divider](/.assets/divider.png)

## Description

A pod based on [`antonioneri/micro`](https://github.com/tonineri/micro) which provides essential tools to troubleshoot containerized SAS Viya environments.

![divider](/.assets/divider.png)

## Prerequisites

Before using the `toolkit`, ensure you have **pod deployment capabilities within the specified namespace(s)**.

![divider](/.assets/divider.png)

## Usage

To get started with the `toolkit`, follow these steps:

- Keeping defaults:

    ```bash
    kubectl -n <namespace> apply -f https://raw.githubusercontent.com/tonineri/toolkit/main/pod-toolkit.yaml
    kubectl -n <namespace> exec -it toolkit -- zsh
    ```

- Customize the [`Dockerfile`](Dockerfile) and/or the [`pod-toolkit.yaml`](pod-toolkit.yaml) file before deploying the pod:

    1. Get the latest version of the tool:

    ```bash
    git clone https://github.com/tonineri/toolkit
    ```

    2. Deploy the pod in your namespace:

    ```bash
    cd toolkit
    kubectl -n <namespace> pod-toolkit.yaml
    ```

    3. Access the pod:

    ```bash
    kubectl -n <namespace> exec -it toolkit -- zsh
    ```

![divider](/.assets/divider.png)

## Contributing

We welcome contributions. Please submit your ideas, bug reports, or feature requests via the [issue tracker](https://github.com/tonineri/toolkit/issues).

![divider](/.assets/divider.png)

## License

This project is licensed under the [Apache 2.0 License](LICENSE.md). 

![divider](/.assets/divider.png)


