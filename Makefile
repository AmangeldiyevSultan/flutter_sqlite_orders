SCRIPTS_DIR := scripts
CODEGEN_SCRIPT := $(SCRIPTS_DIR)/build_runner.sh

codegen:
	sh $(CODEGEN_SCRIPT) 


# By default, we display a message about available tasks
all:
	@echo "Available tasks:"
	@echo " - codegen: build_runner build & dart format"
