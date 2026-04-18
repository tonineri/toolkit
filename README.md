<div align="center">

![SAS Viya](/docs/images/sas-viya.png)

# **Toolkit Pod**

[![License: MIT](https://img.shields.io/badge/license-MIT-yellow.svg)](LICENSE)
[![Build Status](https://github.com/tonineri/toolkit/actions/workflows/build.yaml/badge.svg)](https://github.com/tonineri/toolkit/actions/workflows/build.yaml)
[![Security Scanning](https://img.shields.io/badge/security-grype%20scanned-brightgreen)](https://github.com/tonineri/toolkit/actions/workflows/build.yaml)
[![Security Policy](https://img.shields.io/badge/security-policy-blue)](SECURITY.md)
[![ghcr.io](https://img.shields.io/badge/ghcr.io-toolkit-blue?logo=docker)](https://github.com/tonineri/toolkit/pkgs/container/toolkit)
[![Maintained](https://img.shields.io/badge/maintained%3F-yes-green.svg)](https://github.com/tonineri/toolkit/graphs/commit-activity)
[![Red Hat UBI10](https://img.shields.io/badge/base-UBI10_minimal-red)](https://catalog.redhat.com/en/software/containers/ubi10/ubi-minimal/66f1504a379b9c2cf23e145c)

</div>

![divider](/docs/images/divider.png)

## Table of Contents

- [Disclaimer](#disclaimer)
- [Description](#description)
- [Prerequisites](#prerequisites)
- [Usage](#usage)
- [Decode SAS-encoded passwords](#decode-sas-encoded-passwords)
- [Security](#security)
- [Contributing](#contributing)
- [License](#license)

![divider](/docs/images/divider.png)

## Disclaimer

> [!IMPORTANT]
> This is a **personal project** created and maintained by [Antonio Neri](https://github.com/tonineri) in his individual capacity.
>
> While the author is employed by SAS Institute, this image is **not an official SAS product**, is **not endorsed by SAS Institute**, and is **not supported by SAS Institute** in any way. SAS Institute bears no responsibility for its use, reliability, or any consequences arising from its deployment.
>
> This tool was built to simplify the work of SAS Administrators managing SAS Viya environments and is shared with the community in that spirit. Use it at your own discretion.

![divider](/docs/images/divider.png)

## Description

A pod based on the latest **Red Hat Universal Base Image 10 (Minimal)** `ubi10-minimal:latest` which provides essential tools to troubleshoot containerized SAS Viya environments.

![divider](/docs/images/divider.png)

## Prerequisites

Before using the `toolkit` pod, ensure you have **pod deployment capabilities within the specified namespace(s)**.

![divider](/docs/images/divider.png)

## Usage

To get started with the `toolkit`, follow these steps:

- Keeping defaults:

    ```sh
    # Apply
    kubectl -n <namespace> apply -f https://raw.githubusercontent.com/tonineri/toolkit/main/pod-toolkit.yaml ## For Kubernetes
    kubectl -n <namespace> apply -f https://raw.githubusercontent.com/tonineri/toolkit/main/pod-toolkit-openshift.yaml # For Red Hat OpenShift   

    # Access the pod
    kubectl -n <namespace> exec -it toolkit -- zsh
    ```

- Customize the [`pod-toolkit.yaml`](pod-toolkit.yaml) file before deploying the pod:

    1. Get the latest version of the manifest:

    ```sh
    wget https://raw.githubusercontent.com/tonineri/toolkit/main/pod-toolkit.yaml ## For Kubernetes
    wget https://raw.githubusercontent.com/tonineri/toolkit/main/pod-toolkit-openshift.yaml ## For Red Hat OpenShift   
    ```

    2. Edit the `pod-toolkit.yaml` and deploy the pod in your namespace:

    ```sh
    # Make your modifications
    vi pod-toolkit.yaml ## For Kubernetes
    vi pod-toolkit-openshift.yaml ## For Red Hat OpenShift

    # Apply
    kubectl -n <namespace> apply -f pod-toolkit.yaml ## For Kubernetes
    kubectl -n <namespace> apply -f pod-toolkit-openshift.yaml ## For Red Hat OpenShift    
    ```

    3. Access the pod:

    ```sh
    kubectl -n <namespace> exec -it toolkit -- zsh
    ```

![divider](/docs/images/divider.png)

## Decode SAS-encoded passwords

The `toolkit` pod comes with a built-in `echo-server` to help you decode any `SAS001` through `SAS005` encoded password.

  1. Get the IP of the `toolkit` pod running in the `$VIYA_NS` namespace:

     ```sh
     kubectl get pod toolkit -n <namespace> -o jsonpath='{.status.podIP}'
     ```

  2. On your SAS Viya environment, start a SAS Studio session and execute this code after inputting the **pod's IP** and the **SAS-encoded password** to be decoded in the appropriate `%let` statements:

     ```sas
     /* Input the pod IP and the SAS-encoded password to be decoded here: */

     %let pod_ip = pods.ip.address.here;
     %let encoded_pw = {SAS00X}YOURENCODEDPASSWORDHERE;
     
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
       length full $32767 line $32767 b64 $200 decoded $200;
       input line $32767.;
       pos = index(line, '"Authorization":"Basic ');
       if pos > 0 then do;
         rest = substr(line, pos + length('"Authorization":"Basic '));
         b64 = substr(rest, 1, index(rest, '"') - 1);
         decoded = put(input(strip(b64), $base64x200.), $200.);
         decoded = substr(decoded, index(decoded, ':') + 1);
         put 'Decoded password: ' decoded;
       end;
     run;
     ```

  3. If everything was done correctly, you should be able to see the decoded password in the execution log. For example:

     ```
     Decoded password: YourPassword
     ```

> [!NOTE]
> For the `echo-server` to start with the pod, make sure your [pod-toolkit.yaml](pod-toolkit.yaml) is updated.
> Otherwise, access the pod with `kubectl -n <namespace> exec -it toolkit -- zsh` and then execute `/usr/local/bin/echo-server`.

![divider](/docs/images/divider.png)

## Security

This project takes a transparency-first approach to security. Every image published to `ghcr.io` has been scanned with **[Anchore Grype](https://github.com/anchore/grype)** and passed a critical severity threshold before being pushed.

### Viewing scan results

Security reports are publicly available on every build run — no GitHub account required:

1. Go to **[Actions → Build](../../actions/workflows/build.yaml)**
2. Open the latest successful run
3. Scroll to **Artifacts** at the bottom
4. Download `security-scan-*`

The artifact contains a human-readable findings table (`grype-report.txt`) and a machine-readable SARIF file.

### Scan your own copy

```sh
# Install Grype
curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b /usr/local/bin

# Scan the image
grype ghcr.io/tonineri/toolkit:latest
```

For the full security policy, including how to report vulnerabilities, see [SECURITY.md](SECURITY.md).

![divider](/docs/images/divider.png)

## Contributing

We welcome contributions. Please submit your ideas, bug reports, or feature requests via the [issue tracker](https://github.com/tonineri/toolkit/issues).

![divider](/docs/images/divider.png)

## License

This project is licensed under the [MIT License](LICENSE.md).

![divider](/docs/images/divider.png)