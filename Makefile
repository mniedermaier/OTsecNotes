# Makefile for OT Security Learning Documents
# ============================================

# Configuration
TEX = pdflatex
TEXFLAGS = -interaction=nonstopmode -halt-on-error
BUILD_DIR = build
TEMPLATE_DIR = templates
STYLE_FILE = $(TEMPLATE_DIR)/otsec-template.sty

# Auto-detect document folders (directories matching XXX-* pattern with main.tex)
TOPICS := $(sort $(dir $(wildcard [0-9][0-9][0-9]-*/main.tex)))
TOPICS := $(TOPICS:/=)

# Colors for output
GREEN = \033[0;32m
YELLOW = \033[0;33m
RED = \033[0;31m
CYAN = \033[0;36m
NC = \033[0m

# Default target - build all documents
.PHONY: all
all: $(TOPICS)

# Build a specific topic
.PHONY: $(TOPICS)
$(TOPICS): %: %/main.tex $(STYLE_FILE)
	@echo "$(CYAN)[BUILD]$(NC) $@"
	@mkdir -p $(BUILD_DIR)
	@(cd $@ && TEXINPUTS="../$(TEMPLATE_DIR):$$TEXINPUTS" $(TEX) $(TEXFLAGS) -output-directory=../$(BUILD_DIR) main.tex > /dev/null 2>&1) || \
		(echo "$(RED)[ERROR]$(NC) First pass failed for $@"; TEXINPUTS="$(TEMPLATE_DIR):$$TEXINPUTS" $(TEX) $(TEXFLAGS) -output-directory=$(BUILD_DIR) $@/main.tex; exit 1)
	@(cd $@ && TEXINPUTS="../$(TEMPLATE_DIR):$$TEXINPUTS" $(TEX) $(TEXFLAGS) -output-directory=../$(BUILD_DIR) main.tex > /dev/null 2>&1) || \
		(echo "$(RED)[ERROR]$(NC) Second pass failed for $@"; exit 1)
	@mv $(BUILD_DIR)/main.pdf $@/$@.pdf
	@echo "$(GREEN)[DONE]$(NC) Generated $@/$@.pdf"

# Build all documents in parallel
.PHONY: parallel
parallel:
	@echo "$(CYAN)[PARALLEL]$(NC) Building all documents..."
	@$(MAKE) -j$(shell nproc) all
	@echo "$(GREEN)[DONE]$(NC) All documents built"

# Verbose build for a specific topic (usage: make verbose-01-purdue-model)
verbose-%:
	@echo "$(CYAN)[BUILD]$(NC) $* (verbose)"
	@mkdir -p $(BUILD_DIR)
	cd $* && TEXINPUTS="../$(TEMPLATE_DIR):$$TEXINPUTS" $(TEX) -output-directory=../$(BUILD_DIR) main.tex
	cd $* && TEXINPUTS="../$(TEMPLATE_DIR):$$TEXINPUTS" $(TEX) -output-directory=../$(BUILD_DIR) main.tex
	@mv $(BUILD_DIR)/main.pdf $*/$*.pdf
	@echo "$(GREEN)[DONE]$(NC) Generated $*/$*.pdf"

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
	@for topic in $(TOPICS); do rm -f $$topic/*.pdf; done
	@echo "$(GREEN)[DONE]$(NC) Cleaned all generated files"

# Watch for changes and rebuild (requires inotifywait)
.PHONY: watch
watch:
	@echo "$(YELLOW)[WATCH]$(NC) Watching for changes... (Ctrl+C to stop)"
	@while true; do \
		inotifywait -q -r -e modify $(TOPICS) $(STYLE_FILE) 2>/dev/null; \
		echo "$(YELLOW)[CHANGE]$(NC) Rebuilding..."; \
		$(MAKE) all; \
	done

# List all topics
.PHONY: list
list:
	@echo "$(CYAN)Available topics (auto-detected):$(NC)"
	@for topic in $(TOPICS); do \
		echo "  $$topic/ -> $$topic/$$topic.pdf"; \
	done

# Open all PDFs
.PHONY: view
view: all
	@for topic in $(TOPICS); do \
		xdg-open $$topic/$$topic.pdf 2>/dev/null || open $$topic/$$topic.pdf 2>/dev/null & \
	done

# Create new topic (usage: make new NAME=03-new-topic)
.PHONY: new
new:
	@if [ -z "$(NAME)" ]; then \
		echo "$(RED)[ERROR]$(NC) Usage: make new NAME=003-topic-name"; \
		exit 1; \
	fi
	@if [ -d "$(NAME)" ]; then \
		echo "$(RED)[ERROR]$(NC) Directory $(NAME) already exists"; \
		exit 1; \
	fi
	@mkdir -p $(NAME)/images
	@echo '% ============================================================================' > $(NAME)/main.tex
	@echo '%  $(NAME) - OT Security Learning Resource' >> $(NAME)/main.tex
	@echo '% ============================================================================' >> $(NAME)/main.tex
	@echo '' >> $(NAME)/main.tex
	@echo '\\documentclass[11pt,a4paper]{article}' >> $(NAME)/main.tex
	@echo '\\usepackage{otsec-template}' >> $(NAME)/main.tex
	@echo '' >> $(NAME)/main.tex
	@echo '\\begin{document}' >> $(NAME)/main.tex
	@echo '' >> $(NAME)/main.tex
	@echo '\\maketitlepage' >> $(NAME)/main.tex
	@echo '    {Your Title Here}' >> $(NAME)/main.tex
	@echo '    {Subtitle description}' >> $(NAME)/main.tex
	@echo '    {OT Security Learning Series}' >> $(NAME)/main.tex
	@echo '    {Document XXX \\quad|\\quad January 2026}' >> $(NAME)/main.tex
	@echo '    {Your Name}' >> $(NAME)/main.tex
	@echo '' >> $(NAME)/main.tex
	@echo '\\tableofcontents' >> $(NAME)/main.tex
	@echo '\\newpage' >> $(NAME)/main.tex
	@echo '' >> $(NAME)/main.tex
	@echo '\\section{Introduction}' >> $(NAME)/main.tex
	@echo '' >> $(NAME)/main.tex
	@echo 'Your content here.' >> $(NAME)/main.tex
	@echo '' >> $(NAME)/main.tex
	@echo '\\end{document}' >> $(NAME)/main.tex
	@echo "$(GREEN)[DONE]$(NC) Created $(NAME)/"
	@echo "       Document will be auto-detected on next build"

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
	@echo "  <topic-name>     Build specific topic (e.g., make 010-purdue-model)"
	@echo "  verbose-<topic>  Build with full LaTeX output"
	@echo ""
	@echo "$(CYAN)Utility Targets:$(NC)"
	@echo "  clean            Remove auxiliary files"
	@echo "  distclean        Remove all generated files including PDFs"
	@echo "  watch            Watch for changes and auto-rebuild"
	@echo "  list             List all available topics"
	@echo "  view             Build and open all PDFs"
	@echo "  new NAME=xx      Create new topic from template"
	@echo "  help             Show this help message"
	@echo ""
	@echo "$(CYAN)Auto-detected Topics:$(NC)"
	@for topic in $(TOPICS); do echo "  $$topic/"; done
	@echo ""
	@echo "$(CYAN)Structure:$(NC)"
	@echo "  templates/otsec-template.sty  Shared style (edit to update all docs)"
	@echo "  <topic>/main.tex              Topic source file"
	@echo "  <topic>/images/               Topic-specific images"
	@echo "  <topic>/<topic>.pdf           Generated PDF"
