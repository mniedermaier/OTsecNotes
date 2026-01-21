# Makefile for OT Security Learning Documents
# ============================================

# Configuration
TEX = pdflatex
TEXFLAGS = -interaction=nonstopmode -halt-on-error
BUILD_DIR = build
TEMPLATE_DIR = templates
STYLE_FILE = $(TEMPLATE_DIR)/otsec-template.sty

# Category folders
CATEGORIES := 000-fundamentals 100-standards 200-protocols 300-architecture 400-threats 500-monitoring 600-incident-response 700-assessments 800-solutions

# Auto-detect document folders (nested structure: category/XXX-*/main.tex)
TOPIC_PATHS := $(sort $(dir $(wildcard [0-9]*-*/[0-9]*-*/main.tex)))
TOPIC_PATHS := $(TOPIC_PATHS:/=)

# Extract just the document name (last part of path) for targets
TOPICS := $(notdir $(TOPIC_PATHS))

# Colors for output
GREEN = \033[0;32m
YELLOW = \033[0;33m
RED = \033[0;31m
CYAN = \033[0;36m
NC = \033[0m

# Default target - build all documents
.PHONY: all
all: $(TOPICS)

# Function to find category for a topic
find_category = $(firstword $(foreach cat,$(CATEGORIES),$(if $(wildcard $(cat)/$(1)/main.tex),$(cat))))

# Build a specific topic by name (e.g., make 200-modbus)
.PHONY: $(TOPICS)
$(TOPICS): %: $(STYLE_FILE)
	$(eval CATEGORY := $(call find_category,$@))
	$(eval DOC_PATH := $(CATEGORY)/$@)
	@if [ -z "$(CATEGORY)" ]; then \
		echo "$(RED)[ERROR]$(NC) Topic $@ not found in any category"; \
		exit 1; \
	fi
	@echo "$(CYAN)[BUILD]$(NC) $(DOC_PATH)"
	@mkdir -p $(BUILD_DIR)/$(DOC_PATH)
	@(cd $(DOC_PATH) && TEXINPUTS="../../$(TEMPLATE_DIR):$$TEXINPUTS" $(TEX) $(TEXFLAGS) -output-directory=../../$(BUILD_DIR)/$(DOC_PATH) main.tex > /dev/null 2>&1) || \
		(echo "$(RED)[ERROR]$(NC) First pass failed for $(DOC_PATH)"; cd $(DOC_PATH) && TEXINPUTS="../../$(TEMPLATE_DIR):$$TEXINPUTS" $(TEX) $(TEXFLAGS) -output-directory=../../$(BUILD_DIR)/$(DOC_PATH) main.tex; exit 1)
	@(cd $(DOC_PATH) && TEXINPUTS="../../$(TEMPLATE_DIR):$$TEXINPUTS" $(TEX) $(TEXFLAGS) -output-directory=../../$(BUILD_DIR)/$(DOC_PATH) main.tex > /dev/null 2>&1) || \
		(echo "$(RED)[ERROR]$(NC) Second pass failed for $(DOC_PATH)"; exit 1)
	@mv $(BUILD_DIR)/$(DOC_PATH)/main.pdf $(DOC_PATH)/$@.pdf
	@echo "$(GREEN)[DONE]$(NC) Generated $(DOC_PATH)/$@.pdf"

# Build all documents in parallel
.PHONY: parallel
parallel:
	@echo "$(CYAN)[PARALLEL]$(NC) Building all documents..."
	@$(MAKE) -j$(shell nproc) all
	@echo "$(GREEN)[DONE]$(NC) All documents built"

# Verbose build for a specific topic (usage: make verbose-200-modbus)
verbose-%:
	$(eval CATEGORY := $(call find_category,$*))
	$(eval DOC_PATH := $(CATEGORY)/$*)
	@if [ -z "$(CATEGORY)" ]; then \
		echo "$(RED)[ERROR]$(NC) Topic $* not found in any category"; \
		exit 1; \
	fi
	@echo "$(CYAN)[BUILD]$(NC) $(DOC_PATH) (verbose)"
	@mkdir -p $(BUILD_DIR)/$(DOC_PATH)
	cd $(DOC_PATH) && TEXINPUTS="../../$(TEMPLATE_DIR):$$TEXINPUTS" $(TEX) -output-directory=../../$(BUILD_DIR)/$(DOC_PATH) main.tex
	cd $(DOC_PATH) && TEXINPUTS="../../$(TEMPLATE_DIR):$$TEXINPUTS" $(TEX) -output-directory=../../$(BUILD_DIR)/$(DOC_PATH) main.tex
	@mv $(BUILD_DIR)/$(DOC_PATH)/main.pdf $(DOC_PATH)/$*.pdf
	@echo "$(GREEN)[DONE]$(NC) Generated $(DOC_PATH)/$*.pdf"

# Clean auxiliary files
.PHONY: clean
clean:
	@echo "$(YELLOW)[CLEAN]$(NC) Removing build directory..."
	@rm -rf $(BUILD_DIR)
	@echo "$(GREEN)[DONE]$(NC) Cleaned auxiliary files"

# Clean everything including PDFs
.PHONY: distclean
distclean: clean
	@echo "$(YELLOW)[DISTCLEAN]$(NC) Removing PDFs..."
	@find . -path './[0-9]*-*/[0-9]*-*/*.pdf' -delete
	@echo "$(GREEN)[DONE]$(NC) Cleaned all generated files"

# Watch for changes and rebuild (requires inotifywait)
.PHONY: watch
watch:
	@echo "$(YELLOW)[WATCH]$(NC) Watching for changes... (Ctrl+C to stop)"
	@while true; do \
		inotifywait -q -r -e modify $(TOPIC_PATHS) $(STYLE_FILE) 2>/dev/null; \
		echo "$(YELLOW)[CHANGE]$(NC) Rebuilding..."; \
		$(MAKE) all; \
	done

# List all topics
.PHONY: list
list:
	@echo "$(CYAN)Available documents (auto-detected):$(NC)"
	@echo ""
	@for cat in $(CATEGORIES); do \
		if [ -d "$$cat" ] && ls $$cat/*/main.tex >/dev/null 2>&1; then \
			echo "$(YELLOW)$$cat/$(NC)"; \
			for doc in $$cat/*/; do \
				if [ -f "$$doc/main.tex" ]; then \
					docname=$$(basename $$doc); \
					echo "  $$docname"; \
				fi; \
			done; \
			echo ""; \
		fi; \
	done

# Open all PDFs
.PHONY: view
view: all
	@for path in $(TOPIC_PATHS); do \
		docname=$$(basename $$path); \
		xdg-open $$path/$$docname.pdf 2>/dev/null || open $$path/$$docname.pdf 2>/dev/null & \
	done

# Create new topic (usage: make new NAME=203-new-protocol)
# Automatically places in correct category based on number prefix
.PHONY: new
new:
	@if [ -z "$(NAME)" ]; then \
		echo "$(RED)[ERROR]$(NC) Usage: make new NAME=203-topic-name"; \
		exit 1; \
	fi
	@NUM=$$(echo $(NAME) | grep -oE '^[0-9]+' | head -c1); \
	case $$NUM in \
		0) CATDIR="000-fundamentals" ;; \
		1) CATDIR="100-standards" ;; \
		2) CATDIR="200-protocols" ;; \
		3) CATDIR="300-architecture" ;; \
		4) CATDIR="400-threats" ;; \
		5) CATDIR="500-monitoring" ;; \
		6) CATDIR="600-incident-response" ;; \
		7) CATDIR="700-assessments" ;; \
		8) CATDIR="800-solutions" ;; \
		*) echo "$(RED)[ERROR]$(NC) Invalid document number. Must start with 0-8."; exit 1 ;; \
	esac; \
	if [ -d "$$CATDIR/$(NAME)" ]; then \
		echo "$(RED)[ERROR]$(NC) Directory $$CATDIR/$(NAME) already exists"; \
		exit 1; \
	fi; \
	mkdir -p "$$CATDIR/$(NAME)/images"; \
	echo '% ============================================================================' > "$$CATDIR/$(NAME)/main.tex"; \
	echo '%  $(NAME) - OT Security Learning Resource' >> "$$CATDIR/$(NAME)/main.tex"; \
	echo '% ============================================================================' >> "$$CATDIR/$(NAME)/main.tex"; \
	echo '' >> "$$CATDIR/$(NAME)/main.tex"; \
	echo '\\documentclass[11pt,a4paper]{article}' >> "$$CATDIR/$(NAME)/main.tex"; \
	echo '\\usepackage{otsec-template}' >> "$$CATDIR/$(NAME)/main.tex"; \
	echo '' >> "$$CATDIR/$(NAME)/main.tex"; \
	echo '\\begin{document}' >> "$$CATDIR/$(NAME)/main.tex"; \
	echo '' >> "$$CATDIR/$(NAME)/main.tex"; \
	echo '\\maketitlepage' >> "$$CATDIR/$(NAME)/main.tex"; \
	echo '    {Your Title Here}' >> "$$CATDIR/$(NAME)/main.tex"; \
	echo '    {Subtitle description}' >> "$$CATDIR/$(NAME)/main.tex"; \
	echo '    {OT Security Learning Series}' >> "$$CATDIR/$(NAME)/main.tex"; \
	echo '    {Document XXX \\quad|\\quad January 2026}' >> "$$CATDIR/$(NAME)/main.tex"; \
	echo '    {Your Name}' >> "$$CATDIR/$(NAME)/main.tex"; \
	echo '' >> "$$CATDIR/$(NAME)/main.tex"; \
	echo '\\tableofcontents' >> "$$CATDIR/$(NAME)/main.tex"; \
	echo '\\newpage' >> "$$CATDIR/$(NAME)/main.tex"; \
	echo '' >> "$$CATDIR/$(NAME)/main.tex"; \
	echo '\\section{Introduction}' >> "$$CATDIR/$(NAME)/main.tex"; \
	echo '' >> "$$CATDIR/$(NAME)/main.tex"; \
	echo 'Your content here.' >> "$$CATDIR/$(NAME)/main.tex"; \
	echo '' >> "$$CATDIR/$(NAME)/main.tex"; \
	echo '\\end{document}' >> "$$CATDIR/$(NAME)/main.tex"; \
	echo "$(GREEN)[DONE]$(NC) Created $$CATDIR/$(NAME)/"; \
	echo "       Document will be auto-detected on next build"

# Help
.PHONY: help
help:
	@echo "OT Security Learning Documents - Makefile"
	@echo "=========================================="
	@echo ""
	@echo "$(CYAN)Usage:$(NC) make [target]"
	@echo ""
	@echo "$(CYAN)Build Targets:$(NC)"
	@echo "  all              Build all documents (default)"
	@echo "  parallel         Build all documents in parallel"
	@echo "  <topic-name>     Build specific topic (e.g., make 200-modbus)"
	@echo "  verbose-<topic>  Build with full LaTeX output"
	@echo ""
	@echo "$(CYAN)Utility Targets:$(NC)"
	@echo "  clean            Remove auxiliary files"
	@echo "  distclean        Remove all generated files including PDFs"
	@echo "  watch            Watch for changes and auto-rebuild"
	@echo "  list             List all available topics"
	@echo "  view             Build and open all PDFs"
	@echo "  new NAME=xxx     Create new topic (auto-placed in category)"
	@echo "  help             Show this help message"
	@echo ""
	@echo "$(CYAN)Structure:$(NC)"
	@echo "  000-fundamentals/      Core concepts, models"
	@echo "  100-standards/         Standards & compliance"
	@echo "  200-protocols/         Industrial protocols"
	@echo "  300-architecture/      Network design"
	@echo "  400-threats/           Threats & attacks"
	@echo "  500-monitoring/        Detection & monitoring"
	@echo "  600-incident-response/ IR procedures"
	@echo "  700-assessments/       Security assessments"
	@echo "  800-solutions/         Tools & implementations"
	@echo ""
	@echo "$(CYAN)Auto-detected Documents:$(NC)"
	@for topic in $(TOPICS); do echo "  $$topic"; done
