.PHONY: setup tools hooks

setup: tools hooks

hooks:
	pre-commit install
	pre-commit autoupdate

tools:
	sudo apt update && \
	sudo apt install -y unzip software-properties-common python3 python3-pip python-is-python3 jq && \
	pip install --no-cache-dir pre-commit checkov && \
	python3 -m pip install --upgrade pip && \
	curl -L "$$(curl -s https://api.github.com/repos/terraform-docs/terraform-docs/releases/latest | grep -o -E -m 1 'https://.+?-linux-amd64.tar.gz')" > terraform-docs.tgz && \
	tar -xzf terraform-docs.tgz terraform-docs && rm terraform-docs.tgz && chmod +x terraform-docs && sudo mv terraform-docs /usr/bin/ && \
	curl -L "$$(curl -s https://api.github.com/repos/tenable/terrascan/releases/latest | grep -o -E -m 1 'https://.+?_Linux_x86_64.tar.gz')" > terrascan.tar.gz && \
	tar -xzf terrascan.tar.gz terrascan && rm terrascan.tar.gz && sudo mv terrascan /usr/bin/ && terrascan init && \
	curl -L "$$(curl -s https://api.github.com/repos/terraform-linters/tflint/releases/latest | grep -o -E -m 1 'https://.+?_linux_amd64.zip')" > tflint.zip && \
	unzip tflint.zip && rm tflint.zip && sudo mv tflint /usr/bin/ && \
	curl -L "$$(curl -s https://api.github.com/repos/aquasecurity/tfsec/releases/latest | grep -o -E -m 1 'https://.+?tfsec-linux-amd64')" > tfsec && \
	chmod +x tfsec && sudo mv tfsec /usr/bin/ && \
	curl -L "$$(curl -s https://api.github.com/repos/aquasecurity/trivy/releases/latest | grep -o -E -i -m 1 'https://.+?/trivy_.+?_Linux-64bit.tar.gz')" > trivy.tar.gz && \
	tar -xzf trivy.tar.gz trivy && rm trivy.tar.gz && sudo mv trivy /usr/bin/ && \
	curl -L "$$(curl -s https://api.github.com/repos/infracost/infracost/releases/latest | grep -o -E -m 1 'https://.+?-linux-amd64.tar.gz')" > infracost.tgz && \
	tar -xzf infracost.tgz && rm infracost.tgz && sudo mv infracost-linux-amd64 /usr/bin/infracost && infracost auth login && \
	curl -L "$$(curl -s https://api.github.com/repos/minamijoyo/tfupdate/releases/latest | grep -o -E -m 1 'https://.+?_linux_amd64.tar.gz')" > tfupdate.tar.gz && \
	tar -xzf tfupdate.tar.gz tfupdate && rm tfupdate.tar.gz && sudo mv tfupdate /usr/bin/ && \
	curl -L "$$(curl -s https://api.github.com/repos/minamijoyo/hcledit/releases/latest | grep -o -E -m 1 'https://.+?_linux_amd64.tar.gz')" > hcledit.tar.gz && \
	tar -xzf hcledit.tar.gz hcledit && rm hcledit.tar.gz && sudo mv hcledit /usr/bin/
