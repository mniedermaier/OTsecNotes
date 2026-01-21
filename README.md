<div align="center">

# :shield: OT Security Notes

### Operational Technology Security Learning Series

[![Build PDFs](https://github.com/mniedermaier/OTsecNotes/actions/workflows/build-pdfs.yml/badge.svg)](https://github.com/mniedermaier/OTsecNotes/actions/workflows/build-pdfs.yml)
[![LaTeX](https://img.shields.io/badge/Made%20with-LaTeX-1f425f.svg)](https://www.latex-project.org/)
[![License: CC BY-SA 4.0](https://img.shields.io/badge/License-CC%20BY--SA%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by-sa/4.0/)
[![GitHub Pages](https://img.shields.io/badge/docs-GitHub%20Pages-blue)](https://mniedermaier.github.io/OTsecNotes/)

**Comprehensive learning documents for ICS/SCADA security professionals**

</div>

---

## About This Project

This repository contains a comprehensive collection of professionally formatted learning documents focused on **Operational Technology (OT)** and **Industrial Control System (ICS)** security. The documents are designed to provide clear, vendor-neutral educational content for security professionals, engineers, and students working with critical infrastructure.

Each document covers a specific topic in depth, ranging from foundational concepts like the Purdue Model to advanced subjects such as incident response procedures and security assessments. The series draws from established standards including **IEC 62443**, **NIST SP 800-82**, and real-world case studies of significant OT security incidents.

All documents share a consistent, modern design through a custom LaTeX template featuring color-coded information boxes, security level indicators, and professional typography. The build system automatically detects new documents and generates PDFs through GitHub Actions, making contributions straightforward.

> **Quick Access:** Browse all documents at [mniedermaier.github.io/OTsecNotes](https://mniedermaier.github.io/OTsecNotes/)

---

## Highlights

| | Feature |
|:---:|:---|
| :shield: | **Vendor-Neutral** — Focus on concepts and standards, not specific products |
| :book: | **17+ Documents** — Covering fundamentals to advanced topics |
| :art: | **Professional Design** — Consistent styling with custom LaTeX template |
| :gear: | **Auto-Build** — GitHub Actions automatically generates PDFs |
| :scroll: | **Standards-Based** — References IEC 62443, NIST 800-82, and more |
| :warning: | **Real Case Studies** — Analysis of Stuxnet, TRITON, Ukraine attacks |

---

## Document Categories

Documents are organized by category using a three-digit numbering scheme:

| Range | Category | Description |
|:------|:---------|:------------|
| **001-099** | :bulb: Fundamentals | Core concepts, models, and OT basics |
| **100-199** | :scroll: Standards & Compliance | IEC 62443, NIST 800-82, NERC CIP, etc. |
| **200-299** | :electric_plug: Protocols & Technologies | Modbus, DNP3, OPC UA, EtherNet/IP, etc. |
| **300-399** | :bricks: Architecture & Design | Network segmentation, DMZ design, secure remote access |
| **400-499** | :skull: Threats & Attacks | Attack vectors, case studies, threat landscape |
| **500-599** | :mag: Detection & Monitoring | OT IDS, network monitoring, anomaly detection |
| **600-699** | :fire_extinguisher: Incident Response | IR procedures, forensics, recovery |
| **700-799** | :clipboard: Assessments | Penetration testing, risk assessment, audits |
| **800-899** | :hammer_and_wrench: Solutions & Tools | Firewalls, data diodes, practical implementations |

---

## Quick Start

```bash
# Clone the repository
git clone https://github.com/mniedermaier/OTsecNotes.git
cd OTsecNotes

# Build all documents
make all

# Or build in parallel for faster compilation
make parallel

# Create a new document
make new NAME=250-new-protocol
```

---

## Current Documents

<details>
<summary><strong>Click to expand document list</strong> (17 documents)</summary>

| Document | Title | Category |
|:---------|:------|:---------|
| 001-it-vs-ot | IT vs OT | Fundamentals |
| 010-purdue-model | The Purdue Model | Fundamentals |
| 100-standards-overview | OT Security Standards Overview | Standards & Compliance |
| 110-iec-62443-intro | Introduction to IEC 62443 | Standards & Compliance |
| 200-modbus | Modbus Protocol | Protocols & Technologies |
| 201-opc-ua | OPC UA | Protocols & Technologies |
| 300-network-segmentation | OT Network Segmentation | Architecture & Design |
| 301-secure-remote-access | Secure Remote Access | Architecture & Design |
| 400-ot-incidents-overview | OT Security Incidents Overview | Threats & Attacks |
| 410-stuxnet | Stuxnet | Threats & Attacks |
| 411-ukraine-power-grid | Ukraine Power Grid Attacks | Threats & Attacks |
| 412-triton-trisis | TRITON/TRISIS | Threats & Attacks |
| 500-ot-monitoring | OT Network Monitoring | Detection & Monitoring |
| 510-asset-discovery | OT Asset Discovery | Detection & Monitoring |
| 600-ot-incident-response | OT Incident Response | Incident Response |
| 700-ot-risk-assessment | OT Risk Assessment | Assessments |
| 810-application-whitelisting | Application Whitelisting & System Lockdown | Solutions & Tools |

</details>

---

## Project Structure

```
OTsecNotes/
├── templates/
│   └── otsec-template.sty    # Shared LaTeX style (edit to update all docs)
├── XXX-topic-name/
│   ├── main.tex              # Document source
│   ├── images/               # Document-specific images
│   └── XXX-topic-name.pdf    # Generated PDF
├── .github/workflows/
│   └── build-pdfs.yml        # CI/CD (auto-detects documents)
├── Makefile                  # Build system (auto-detects documents)
└── README.md
```

---

## Building Documents

### Prerequisites

- LaTeX distribution (TeX Live recommended)
- Required packages: tikz, tcolorbox, fontawesome5, fancyhdr, etc.

### Build Commands

```bash
# Build all documents (auto-detected)
make all

# Build all documents in parallel
make parallel

# Build a specific document
make 010-purdue-model

# Build with verbose output (for debugging)
make verbose-010-purdue-model

# Clean auxiliary files
make clean

# Clean everything including PDFs
make distclean

# Watch for changes and auto-rebuild
make watch

# List all available topics (auto-detected)
make list

# Build and open all PDFs
make view
```

### Creating a New Document

```bash
make new NAME=XXX-topic-name
```

New documents are automatically detected on the next build - no need to edit the Makefile.

---

## Template Features

The shared template (`templates/otsec-template.sty`) provides:

- Modern, professional styling with industrial security theme
- Custom colored boxes: `infobox`, `warningbox`, `dangerbox`, `successbox`, `tipbox`, `definitionbox`, `conceptbox`
- Risk level badges: `\riskcritical`, `\riskhigh`, `\riskmedium`, `\risklow`
- Security level indicators: `\slone`, `\sltwo`, `\slthree`, `\slfour`
- Purdue zone indicators: `\zonezero`, `\zoneone`, `\zonetwo`, `\zonethree`, `\zonedmz`, `\zonefour`
- Code listings with dark theme
- FontAwesome icons

### Title Page

```latex
\maketitlepage
    {Document Title}
    {Subtitle description}
    {OT Security Learning Series}
    {Document XXX \quad|\quad Month Year}
    {Contributor 1, Contributor 2}
```

---

## Contributing

1. Create a new document using `make new NAME=XXX-topic-name`
2. Choose the appropriate category number range
3. Add your content to `XXX-topic-name/main.tex`
4. Build and verify with `make XXX-topic-name`

---

## CI/CD

PDFs are automatically built on every push to `main` using GitHub Actions. New documents are auto-detected.

### Accessing PDFs

- **GitHub Pages**: Latest PDFs are available at `https://<username>.github.io/OTsecNotes/`
- **Artifacts**: Download from the Actions tab (retained for 30 days)

### Setup GitHub Pages

1. Go to repository Settings → Pages
2. Set Source to "GitHub Actions"

---

## License

This work is licensed under a [Creative Commons Attribution-ShareAlike 4.0 International License](https://creativecommons.org/licenses/by-sa/4.0/).

---

## Disclaimer

> :robot: This content was created with the assistance of AI. While every effort has been made to ensure accuracy, this material is provided on a best-effort basis without any guarantees for correctness or completeness. Always verify critical information against official sources and current standards documents before applying it in production environments.

---

<div align="center">

**[Browse Documents](https://mniedermaier.github.io/OTsecNotes/)** · **[Report Issue](https://github.com/mniedermaier/OTsecNotes/issues)** · **[Request Document](https://github.com/mniedermaier/OTsecNotes/issues/new?template=new-document-request.yml)**

</div>
