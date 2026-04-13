<div align="center">

![SAS Viya](/docs/images/sas-viya.png)

# Security Policy

</div>

![divider](/docs/images/divider.png)

> [!IMPORTANT]
> This is a **personal project** created and maintained by [Antonio Neri](https://github.com/tonineri) in his individual capacity.
>
> While the author is employed by SAS Institute, this image is **not an official SAS product**, is **not endorsed by SAS Institute**, and is **not supported by SAS Institute** in any way. SAS Institute bears no responsibility for its use, reliability, or any consequences arising from its deployment.
>
> This tool was built to simplify the work of SAS Administrators managing SAS Viya environments and is shared with the community in that spirit. Use it at your own discretion.

![divider](/docs/images/divider.png)

## Supported Versions

| Version | Supported |
|---------|-----------|
| `latest` | ✅ |

---

## Security Scanning

This project uses automated, multi-layer security scanning on every build and on a **weekly schedule**, ensuring the published image is continuously monitored against the latest known vulnerabilities.

### Container Scanning — Anchore Grype

Every image build is scanned with **[Anchore Grype](https://github.com/anchore/grype)** against multiple vulnerability databases (NVD, RHSA, GitHub Advisory, and more) before being pushed to the registry.

- Builds with **critical** severity findings are **blocked from being pushed** to `ghcr.io`
- Scan results are uploaded to the GitHub Security tab as SARIF reports
- Human-readable reports are published as **publicly downloadable artifacts** on every build run

### Accessing Scan Reports

Security scan results are publicly available in two ways:

1. **Actions tab** → select any [Build workflow run](../../actions/workflows/build.yaml) → scroll to **Artifacts** → download `security-scan-*`

   The artifact contains:
   - `grype-report.txt` — human-readable table of all findings with severity, CVE ID, package, and fix version
   - `results.sarif` — machine-readable SARIF report for tooling integration
   - `scan-summary.md` — brief summary with image and scan metadata

2. **Run your own scan** at any time against the published image:

   ```sh
   # Install Grype
   curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b /usr/local/bin

   # Scan the image
   grype ghcr.io/tonineri/toolkit:latest
   ```

### Dependency Scanning — GitHub Dependabot

Dependencies are monitored continuously via **GitHub Dependabot**:

| Ecosystem | Schedule | Auto-merge |
|-----------|----------|------------|
| Docker base image | Weekly | ✅ All updates |
| GitHub Actions | Daily | ✅ Patch and minor only |

---

## Base Image

This image is built on **[Red Hat Universal Base Image 9 Minimal](https://catalog.redhat.com/software/containers/ubi9/ubi-minimal/615bd9b4075b022acc111bf5)** (`ubi9-minimal:latest`), which receives regular security patches from Red Hat. The base image is automatically updated weekly via Dependabot.

---

## Reporting a Vulnerability

If you discover a security vulnerability in this project that is **not already captured by the automated scanning**, please do not open a public GitHub issue.

Report it privately via **[GitHub Private Vulnerability Reporting](../../security/advisories/new)**.

Please include:

- A clear description of the vulnerability
- Steps to reproduce
- Potential impact and affected versions
