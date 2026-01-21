# Claude Project Context - OT Security Learning Notes

## Project Overview
A collection of LaTeX documents covering Operational Technology (OT) and Industrial Control System (ICS) security topics. Documents use a shared template for consistent styling.

## Document Numbering Scheme
Documents are organized by category using three-digit numbers:

| Range | Category | Description |
|-------|----------|-------------|
| 001-099 | Fundamentals | Core concepts, models, OT basics |
| 100-199 | Standards & Compliance | IEC 62443, NIST, regional regulations |
| 200-299 | Protocols & Technologies | Modbus, DNP3, OPC UA, EtherNet/IP |
| 300-399 | Architecture & Design | Network segmentation, DMZ, remote access |
| 400-499 | Threats & Attacks | Attack vectors, case studies |
| 500-599 | Detection & Monitoring | IDS, network monitoring |
| 600-699 | Incident Response | IR procedures, forensics |
| 700-799 | Assessments | Pentesting, risk assessment |
| 800-899 | Solutions & Tools | Practical implementations |

## Current Documents

Documents are auto-detected by the Makefile. Run `make list` to see all available documents.

**000-fundamentals/**
- `001-it-vs-ot` - IT vs OT
- `010-purdue-model` - The Purdue Model

**100-standards/**
- `100-standards-overview` - Global OT Security Standards Overview
- `110-iec-62443-intro` - Introduction to IEC 62443
- `111-nist-800-82` - NIST SP 800-82

**200-protocols/**
- `200-modbus` - Modbus Protocol
- `201-opc-ua` - OPC UA
- `202-dnp3` - DNP3 Protocol

**300-architecture/**
- `300-network-segmentation` - OT Network Segmentation
- `301-secure-remote-access` - Secure Remote Access
- `302-dmz-design` - Industrial DMZ Design

**400-threats/**
- `400-ot-incidents-overview` - OT Security Incidents Overview
- `410-stuxnet` - Stuxnet
- `411-ukraine-power-grid` - Ukraine Power Grid Attacks
- `412-triton-trisis` - TRITON/TRISIS
- `413-industroyer` - Industroyer/CrashOverride

**500-monitoring/**
- `500-ot-monitoring` - OT Network Monitoring
- `510-asset-discovery` - OT Asset Discovery

**600-incident-response/**
- `600-ot-incident-response` - OT Incident Response

**700-assessments/**
- `700-ot-risk-assessment` - OT Risk Assessment
- `710-ot-pentesting` - OT Penetration Testing

**800-solutions/**
- `810-application-whitelisting` - Application Whitelisting & System Lockdown

## Project Structure
```
OTsecNotes/
├── 000-fundamentals/         # Category folders contain documents
│   ├── 001-it-vs-ot/
│   │   ├── main.tex
│   │   ├── images/
│   │   └── 001-it-vs-ot.pdf
│   └── 010-purdue-model/
├── 100-standards/
├── 200-protocols/
├── 300-architecture/
├── 400-threats/
├── 500-monitoring/
├── 600-incident-response/
├── 700-assessments/
├── 800-solutions/
├── templates/
│   └── otsec-template.sty    # Shared LaTeX style - ALL docs use this
├── .github/workflows/
│   └── build-pdfs.yml        # GitHub Actions CI/CD
├── Makefile                  # Build system
├── README.md                 # User documentation
└── CLAUDE.md                 # This file
```

## Template Usage (otsec-template.sty)

### Title Page Command
```latex
\maketitlepage
    {Document Title}
    {Subtitle description}
    {OT Security Learning Series}
    {Document XXX \quad|\quad Month Year}
    {Contributor 1, Contributor 2}
```

### Available Boxes
- `\begin{infobox}` - Blue info box
- `\begin{warningbox}` - Yellow warning box
- `\begin{dangerbox}` - Red critical/danger box
- `\begin{successbox}` - Green key point box
- `\begin{tipbox}` - Cyan tip box
- `\begin{definitionbox}{Title}` - Definition with custom title
- `\begin{conceptbox}{Title}` - Concept explanation box

### Badges and Indicators
- Risk levels: `\riskcritical`, `\riskhigh`, `\riskmedium`, `\risklow`
- Security levels (IEC 62443): `\slone`, `\sltwo`, `\slthree`, `\slfour`
- Purdue zones: `\zonezero`, `\zoneone`, `\zonetwo`, `\zonethree`, `\zonedmz`, `\zonefour`

### Icons (FontAwesome5)
Use `\faIcon{icon-name}` for icons. Pre-defined: `\iconShield`, `\iconWarning`, `\iconInfo`, `\iconNetwork`, etc.

## Build Commands
```bash
make all                    # Build all documents (auto-detected)
make parallel               # Build in parallel
make list                   # List all auto-detected documents by category
make XXX-topic-name         # Build specific document (e.g., make 200-modbus)
make verbose-XXX-topic-name # Build with full output (debugging)
make clean                  # Remove build artifacts
make distclean              # Remove all generated files including PDFs
make new NAME=XXX-topic     # Create new document (auto-placed in category)
```

**Note:** When creating a new document with `make new`, it is automatically placed in the correct category folder based on its number prefix (e.g., `203-topic` goes into `200-protocols/`).

## Style Guidelines

### Content Rules
- Do NOT reference specific vendor solutions/products
- Do NOT include training programs or certifications
- Do NOT reference other documents in the series (e.g., "See Document 410") - each document must be standalone to avoid maintenance complexity
- Do NOT exceed 10 pages per document - keep content focused and concise
- DO include standards, government resources, and books in Further Reading
- Use `\url{}` for links (xurl package handles line breaks)

### Further Reading Section Structure
```latex
\section{Further Reading}

\subsection*{Standards and Guidelines}
\begin{itemize}
    \item \textbf{Standard Name} -- Description\\
          \url{https://...}
\end{itemize}

\subsection*{Resources}
...

\subsection*{Books}
\begin{itemize}
    \item Author -- \textit{Book Title} (Publisher)
\end{itemize}
```

### Document Structure
Each document should have:
1. Title page with contributors
2. Table of contents
3. Introduction with infobox
4. Main content sections
5. Summary with definitionbox for key takeaways
6. Further Reading section
7. Footer: "Part of the OT Security Learning Series"

## Design Notes

### Title Page Logo
The title page features a shield with gear icon (top right) representing industrial security. This is defined in otsec-template.sty.

### Colors
- Primary: `#0F172A` (dark navy)
- Accent: `#0EA5E9` (cyan)
- Success: `#10B981` (green)
- Warning: `#F59E0B` (amber)
- Danger: `#EF4444` (red)
- Info: `#3B82F6` (blue)

## GitHub Actions
- Builds PDFs on push to main
- Uploads as artifacts (30 day retention)
- Deploys to GitHub Pages with index page
- Enable Pages in repo Settings → Source: "GitHub Actions"
