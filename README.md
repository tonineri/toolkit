<div align="center">

![SAS Viya](/docs/images/sas-viya.png)

# **Toolkit Pod**

[![License: MIT](https://img.shields.io/badge/license-MIT-yellow.svg)](LICENSE)
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

## Decode SAS-encoded passwords

The `toolkit` pod comes with a built-in `echo-server` to help you decode a SAS-encoded password.

  1. Get the IP of the `toolkit` pod running in the `$VIYA_NS` namespace:

     ```sh
     kubectl get pod toolkit -n $VIYA_NS -o jsonpath='{.status.podIP}'
     ```

  2. On your SAS Viya environment, start a SAS Studio session and execute this code after input the **pod's IP** and the **SAS-encoded password** to be decoded in the appropriate `%let` statements:

     ```sas
     /* Input the pod IP and the SAS-encoded password to be decoded here: */

     %let pod_ip = 10.244.8.28;
     %let encoded_pw = {SAS002}YOURENCODEDPASSWORDHERE;
     
     /* Leave the following code as-is */
 
     filename out TEMP;

     proc http
       webusername="a"
       webpassword="&encoded_pw"
       auth_basic
       method="GET"
       url="http://&pod_ip:8080/"
       out=out;
     run;
     
     data _null_;
       infile out lrecl=32767 truncover;
       length full $32767 line $1000;
       retain full '';
       input line $1000.;
       full = cats(full, strip(line));
       if index(full, '"authorization"') > 0 and index(full, 'Basic ') > 0 then do;
         pos = index(full, 'Basic ') + 6;
         b64 = substr(full, pos, index(substr(full, pos), '"') - 1);
         decoded = put(input(strip(b64), $base64x200.), $200.);
         decoded = substr(decoded, index(decoded, ':') + 1);
         put 'Decoded password: ' decoded;
         stop;
       end;
     run;
     ```

  3. If everything was done correctly, you should be able to see the decoded password in the execution log. For example:

     ```
     Decoded password: YourPassword
     ```

![divider](/docs/images/divider.png)

## Contributing

We welcome contributions. Please submit your ideas, bug reports, or feature requests via the [issue tracker](https://github.com/tonineri/toolkit/issues).

![divider](/docs/images/divider.png)

## License

This project is licensed under the [MIT License](LICENSE.md).

![divider](/docs/images/divider.png)
