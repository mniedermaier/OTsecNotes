# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

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
| 500-599 | Detection & Monitoring | IDS, network monitoring, SIEM |
| 600-699 | Incident Response | IR procedures, forensics |
| 700-799 | Assessments | Pentesting, risk assessment, audits |
| 800-899 | Solutions & Tools | Practical implementations |

## Current Documents

Documents are auto-detected by the Makefile. Run `make list` to see all available documents.

**000-fundamentals/** (9 documents)
- `001-it-vs-ot` - IT vs OT
- `010-purdue-model` - The Purdue Model
- `020-plc-basics` - PLC Basics
- `030-hmi-scada-basics` - HMI and SCADA Basics
- `040-safety-systems` - Safety Instrumented Systems
- `050-ot-terminology` - OT Terminology
- `060-ot-lifecycle` - OT System Lifecycle
- `070-industrial-networks` - Industrial Networks
- `080-rtu-basics` - RTU Basics

**100-standards/** (7 documents)
- `100-standards-overview` - Global OT Security Standards Overview
- `110-iec-62443-intro` - Introduction to IEC 62443
- `111-nist-800-82` - NIST SP 800-82
- `120-iec-62443-sl-mapping` - IEC 62443 Security Level Mapping
- `130-nerc-cip` - NERC CIP Standards
- `140-nis2-directive` - EU NIS2 Directive
- `145-cyber-resilience-act` - EU Cyber Resilience Act

**200-protocols/** (8 documents)
- `200-modbus` - Modbus Protocol
- `201-opc-ua` - OPC UA
- `202-dnp3` - DNP3 Protocol
- `203-ethernet-ip` - EtherNet/IP
- `204-profinet` - PROFINET
- `205-bacnet` - BACnet
- `206-iec-61850` - IEC 61850
- `207-s7comm` - S7comm Protocol

**300-architecture/** (9 documents)
- `300-network-segmentation` - OT Network Segmentation
- `301-secure-remote-access` - Secure Remote Access
- `302-dmz-design` - Industrial DMZ Design
- `303-zone-conduit-model` - Zone and Conduit Model
- `304-data-diodes` - Data Diodes
- `305-wireless-in-ot` - Wireless in OT Environments
- `306-ot-cloud-connectivity` - OT Cloud Connectivity
- `308-zero-trust-ot` - Zero Trust for OT
- `309-purdue-model-limitations` - Purdue Model Limitations

**400-threats/** (10 documents)
- `400-ot-incidents-overview` - OT Security Incidents Overview
- `410-stuxnet` - Stuxnet
- `411-ukraine-power-grid` - Ukraine Power Grid Attacks
- `412-triton-trisis` - TRITON/TRISIS
- `413-industroyer` - Industroyer/CrashOverride
- `414-colonial-pipeline` - Colonial Pipeline Attack
- `415-oldsmar` - Oldsmar Water Treatment Attack
- `420-ot-attack-vectors` - OT Attack Vectors
- `421-cyber-kill-chain` - ICS Cyber Kill Chain
- `422-supply-chain-attacks` - OT Supply Chain Attacks

**500-monitoring/** (6 documents)
- `500-ot-monitoring` - OT Network Monitoring
- `510-asset-discovery` - OT Asset Discovery
- `520-ids-ips-ot` - Intrusion Detection for OT
- `530-siem-for-ot` - SIEM for OT Environments
- `540-anomaly-detection` - Anomaly Detection in OT
- `560-ot-soc-design` - OT Security Operations Center

**600-incident-response/** (5 documents)
- `600-ot-incident-response` - OT Incident Response
- `610-ot-forensics` - OT Forensics
- `620-containment-strategies` - Containment Strategies
- `630-recovery-procedures` - Recovery Procedures
- `650-tabletop-exercises` - OT Tabletop Exercises

**700-assessments/** (4 documents)
- `700-ot-risk-assessment` - OT Risk Assessment
- `710-ot-pentesting` - OT Penetration Testing
- `720-vulnerability-management` - OT Vulnerability Management
- `730-security-audits` - OT Security Audits

**800-solutions/** (11 documents)
- `810-application-whitelisting` - Application Whitelisting & System Lockdown
- `820-network-access-control` - Network Access Control
- `830-endpoint-protection` - Endpoint Protection
- `835-epp-edr` - Endpoint Protection Platforms
- `840-secure-media-handling` - Secure Media Handling
- `841-it-ot-file-transfer` - IT/OT File Transfer
- `850-backup-recovery` - Backup and Recovery
- `860-patch-management` - Patch Management
- `870-encryption-in-ot` - Encryption in OT Environments
- `880-privileged-access` - Privileged Access Management
- `890-device-management` - Device Management in OT

## Project Structure
```
OTsecNotes/
├── 000-fundamentals/         # Category folders contain documents
│   ├── 001-it-vs-ot/
│   │   ├── main.tex
│   │   ├── images/
│   │   └── 001-it-vs-ot.pdf
│   └── ...
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

### Required Packages for TikZ Figures
When using TikZ figures with `[H]` placement, add at the document preamble:
```latex
\usepackage{float}
```

### Title Page Command
```latex
\maketitlepage
    {Document Title}
    {Subtitle description}
    {OT Security Learning Series}
    {Document XXX \quad|\quad January 2026}
    {Matthias Niedermaier}
```

**Note:** Use "Matthias Niedermaier" as the contributor for consistency.

### Available Boxes
- `\begin{infobox}` - Blue info box (use in Introduction)
- `\begin{warningbox}` - Yellow warning box (risks, cautions)
- `\begin{dangerbox}` - Red critical/danger box (critical warnings)
- `\begin{successbox}` - Green key point box (recommendations)
- `\begin{tipbox}` - Cyan tip box (helpful hints)
- `\begin{definitionbox}{Title}` - Definition with custom title (use in Summary)
- `\begin{conceptbox}{Title}` - Concept explanation box
- `\begin{quotebox}` - Gray quote box

### Badges and Indicators
- Risk levels: `\riskcritical`, `\riskhigh`, `\riskmedium`, `\risklow`
- Security levels (IEC 62443): `\slone`, `\sltwo`, `\slthree`, `\slfour`
- Purdue zones: `\zonezero`, `\zoneone`, `\zonetwo`, `\zonethree`, `\zonedmz`, `\zonefour`

### Icons (FontAwesome5)
Use `\faIcon{icon-name}` for icons. Pre-defined shortcuts:
- `\iconShield`, `\iconWarning`, `\iconInfo`, `\iconNetwork`
- `\iconBook`, `\iconLock`, `\iconSuccess`, `\iconDanger`, `\iconTip`

## TikZ Graphics Guidelines

### Color Aliases
Always define these color aliases at the start of documents with TikZ graphics:
```latex
% Define colors for TikZ
\colorlet{otprimary}{primary}
\colorlet{otaccent}{accent}
\colorlet{otsuccess}{success}
\colorlet{otwarning}{warning}
\colorlet{otdanger}{danger}
\colorlet{otinfo}{info}
```

### Reserved Style Names - AVOID
Do NOT use these names for TikZ styles (they conflict with built-in TikZ keys):
- `step` - Use `stepbox` instead
- `node` - Use `nodebox` instead
- `path` - Use `pathbox` instead

### Common TikZ Patterns
**Box style:**
```latex
box/.style={rectangle, draw, thick, rounded corners=3pt, minimum width=2.5cm,
            minimum height=1cm, align=center, font=\small}
```

**Arrow style:**
```latex
arrow/.style={->, thick, >=stealth}
```

**Numbered step list:**
```latex
stepbox/.style={rectangle, draw, thick, fill=otaccent!15, minimum width=8cm,
                minimum height=0.7cm, rounded corners=3pt, font=\small},
num/.style={circle, fill=otprimary, text=white, font=\small\bfseries, minimum size=0.6cm}
```

### Figure Placement
Use `[H]` for precise placement (requires `\usepackage{float}`):
```latex
\begin{figure}[H]
\centering
\begin{tikzpicture}[...]
...
\end{tikzpicture}
\caption{Description}
\end{figure}
```

## Table Styling

### Standard Table Format
```latex
\begin{table}[H]
\centering
\small
\rowcolors{2}{lightgray}{white}
\begin{tabular}{p{4cm}p{9cm}}
\rowcolor{primary}
\textcolor{white}{\bfseries Column 1} & \textcolor{white}{\bfseries Column 2} \\
\midrule
Row 1 data & Description \\
Row 2 data & Description \\
\end{tabular}
\caption{Table caption}
\end{table}
```

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

### URL Accessibility Requirements
All URLs in the Further Reading sections must be verified as accessible before inclusion:
- **Verify before adding:** Check that URLs return HTTP 200 status
- **Use official sources:** Prefer official organization URLs over third-party mirrors
- **Avoid deep links:** Use stable top-level pages when possible (e.g., `/standards/` instead of `/standards/page/123`)
- **Periodic review:** URLs should be checked periodically as websites restructure
- **Common working URLs:**
  - NIST publications: `https://csrc.nist.gov/pubs/sp/...`
  - IEC standards: `https://webstore.iec.ch/publication/...`
  - ISA standards: `https://www.isa.org/standards-and-publications/isa-standards/...`
  - CISA resources: `https://www.cisa.gov/topics/...` or `https://www.cisa.gov/resources-tools/...`
  - SANS ICS: `https://www.sans.org/cybersecurity-focus-areas/industrial-control-systems-security`
  - NERC CIP: `https://www.nerc.com/standards/reliability-standards/cip`
  - Modbus: `https://www.modbus.org/modbus-specifications`

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
2. Table of contents followed by `\newpage`
3. Introduction section with `infobox`
4. Main content sections with figures and tables
5. Summary section with `definitionbox` titled "Key Takeaways"
6. Further Reading section
7. Footer: `\textit{Part of the OT Security Learning Series}`

### Summary Section Template
```latex
\section{Summary}

\begin{definitionbox}{Key Takeaways}
\begin{itemize}
    \item \textbf{Point 1:} Description
    \item \textbf{Point 2:} Description
    ...
\end{itemize}
\end{definitionbox}
```

### Footer Template
```latex
\vfill
\begin{center}
\textit{Part of the OT Security Learning Series}
\end{center}
```

## Design Notes

### Title Page Logo
The title page features a shield with gear icon (top right) representing industrial security. This is defined in otsec-template.sty.

### Colors
- Primary: `#0F172A` (dark navy) - Headers, main text
- Accent: `#0EA5E9` (cyan) - Links, highlights
- Success: `#10B981` (green) - Positive/recommendations
- Warning: `#F59E0B` (amber) - Cautions
- Danger: `#EF4444` (red) - Critical warnings
- Info: `#3B82F6` (blue) - Information

### Zone Colors (Purdue Model)
- Zone 0: `#7C3AED` (purple)
- Zone 1: `#2563EB` (blue)
- Zone 2: `#0891B2` (teal)
- Zone 3: `#059669` (green)
- Zone 3.5/DMZ: `#D97706` (orange)
- Zone 4/5: `#DC2626` (red)

## GitHub Actions
- Builds PDFs on push to main
- Uploads as artifacts (30 day retention)
- Deploys to GitHub Pages with index page
- Enable Pages in repo Settings → Source: "GitHub Actions"

## Updating This File
When adding new documents, update the "Current Documents" section to maintain an accurate reference. The document count per category is shown in parentheses.
