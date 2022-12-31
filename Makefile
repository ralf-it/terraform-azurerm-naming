include ~/.make/forces.mk

#███████████████████████████████████████████████████████████████████████████████████████████████████
#████ Development
#███████████████████████████████████████████████████████████████████████████████████████████████████

PLAYBOOKS_DIR :=
PATH_MODULES := modules

delete-tag: /gtd ## [git/tag] delete tag locally and remotely

release-tag: /version-increment-patch /GACMTP ## [git/tag] push as new tag

release-tag-force: /version-increment-patch /GACMTPF ## [git/tag] force push as a tag

docs: /tf-docs ## [docs] generate documentation
	set -x

all: build format validate ## [naming] build, format and validate
	set -x

.POSIX:
install: ## [naming] install dependencies
	set -x
	command -v $(TF) >/dev/null 2>&1 || go install github.com/hashicorp/terraform@v1.2.5
	command -v terraform-docs >/dev/null 2>&1 || go install github.com/terraform-docs/terraform-docs@v0.16.0
	command -v tfsec >/dev/null 2>&1 || go install github.com/aquasecurity/tfsec/cmd/tfsec@latest
	command -v tflint >/dev/null 2>&1 || go install github.com/terraform-linters/tflint@v0.38.1

build: install generate ## [naming] build the module
	set -x

generate: ## [naming] generate the module
	set -x
	go run main.go

format: ## [naming] format the module
	set -x
	terraform fmt

validate: ## [naming] validate the module
	set -x
	terraform fmt --check
	terraform validate -no-color
	tflint --no-color