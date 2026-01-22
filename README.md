<div align="center">

# :shield: OT Security Notes

### Operational Technology Security Learning Series

[![Build PDFs](https://github.com/mniedermaier/OTsecNotes/actions/workflows/build-pdfs.yml/badge.svg)](https://github.com/mniedermaier/OTsecNotes/actions/workflows/build-pdfs.yml)
[![LaTeX](https://img.shields.io/badge/Made%20with-LaTeX-1f425f.svg)](https://www.latex-project.org/)
[![License: CC BY-SA 4.0](https://img.shields.io/badge/License-CC%20BY--SA%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by-sa/4.0/)

---

## :books: Read the Documents

### **[:point_right: mniedermaier.github.io/OTsecNotes :point_left:](https://mniedermaier.github.io/OTsecNotes/)**

All documents are available as PDFs on GitHub Pages.
No download or build required — just click and read.

---

</div>

## About This Project

This repository contains the **source files** for the OT Security Notes learning series.

**Looking to read the documents?** Visit **[mniedermaier.github.io/OTsecNotes](https://mniedermaier.github.io/OTsecNotes/)**

**Looking to contribute or build locally?** Continue reading below.

The documents provide clear, vendor-neutral educational content on **Operational Technology (OT)** and **Industrial Control System (ICS)** security for security professionals, engineers, and students. Topics range from foundational concepts like the Purdue Model to advanced subjects such as incident response and security assessments. The series references established standards including **IEC 62443**, **NIST SP 800-82**, and real-world case studies. All documents are concise — **under 10 pages each**.

---

## Highlights

| | Feature |
|:---:|:---|
| :shield: | **Vendor-Neutral** — Focus on concepts and standards, not specific products |
| :book: | **Documents** — Covering fundamentals to advanced topics |
| :scroll: | **Standards-Based** — References IEC 62443, NIST 800-82, and more |
| :warning: | **Real Case Studies** — Analysis of Stuxnet, TRITON, Ukraine attacks |
| :balance_scale: | **Open License** — CC BY-SA 4.0 |

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

## Project Structure

```
OTsecNotes/
├── 000-fundamentals/           # Core concepts, models
│   ├── 001-it-vs-ot/
│   └── 010-purdue-model/
├── 100-standards/              # Standards & compliance
├── 200-protocols/              # Industrial protocols
├── 300-architecture/           # Network design
├── 400-threats/                # Threats & attacks
├── 500-monitoring/             # Detection & monitoring
├── 600-incident-response/      # IR procedures
├── 700-assessments/            # Security assessments
├── 800-solutions/              # Tools & implementations
├── templates/
│   └── otsec-template.sty      # Shared LaTeX style
├── .github/workflows/
│   └── build-pdfs.yml          # CI/CD pipeline
├── Makefile                    # Build system
└── README.md

# Each document folder contains:
category/XXX-topic-name/
├── main.tex                    # Document source
├── images/                     # Document-specific images
└── XXX-topic-name.pdf          # Generated PDF
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
   - Documents are automatically placed in the correct category folder based on their number
2. Add your content to the generated `main.tex` file
3. Build and verify with `make XXX-topic-name`
4. Run `make list` to see all detected documents

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
