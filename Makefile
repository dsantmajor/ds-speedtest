# Standalone mode
# If you want to install LibreSpeed on a single server, you need to configure it in standalone mode. To do this, set the MODE environment variable to standalone.

# The test can be accessed on port 80.

# Here's a list of additional environment variables available in this mode:

# TITLE: Title of your speedtest. Default value: LibreSpeed
# TELEMETRY: Whether to enable telemetry or not. Default value: false
# ENABLE_ID_OBFUSCATION: When set to true with telemetry enabled, test IDs are obfuscated, to avoid exposing the database internal sequential IDs. Default value: false
# REDACT_IP_ADDRESSES: When set to true with telemetry enabled, IP addresses and hostnames are redacted from the collected telemetry, for better privacy. Default value: false
# PASSWORD: Password to access the stats page. If not set, stats page will not allow accesses.
# EMAIL: Email address for GDPR requests. Must be specified when telemetry is enabled.
# IPINFO_APIKEY: API key for ipinfo.io. Optional, but required if you expect to serve a large number of tests
# DISABLE_IPINFO: If set to true, ISP info and distance will not be fetched from ipinfo.io. Default: value: false
# DISTANCE: When DISABLE_IPINFO is set to false, this specifies how the distance from the server is measured. Can be either km for kilometers, mi for miles, or an empty string to disable distance measurement. Default value: km
# If telemetry is enabled, a stats page will be available at http://your.server/results/stats.php, but a password must be specified.

# Example
# This command starts LibreSpeed in standalone mode, with the default settings, on port 80:

# docker run -e MODE=standalone -p 80:80 -it adolfintel/speedtest
# This command starts LibreSpeed in standalone mode, with telemetry, ID obfuscation and a stats password, on port 80:

# docker run -e MODE=standalone -e TELEMETRY=true -e ENABLE_ID_OBFUSCATION=true -e PASSWORD="botnet!123" -p 80:80 -it adolfintel/speedtest

TITLE=dsLibreSpeed
# TELEMETRY: Whether to enable telemetry or not. Default value: false
# ENABLE_ID_OBFUSCATION: When set to true with telemetry enabled, test IDs are obfuscated, to avoid exposing the database internal sequential IDs. Default value: false
# REDACT_IP_ADDRESSES: When set to true with telemetry enabled, IP addresses and hostnames are redacted from the collected telemetry, for better privacy. Default value: false
# PASSWORD: Password to access the stats page. If not set, stats page will not allow accesses.
# EMAIL: Email address for GDPR requests. Must be specified when telemetry is enabled.
# IPINFO_APIKEY: API key for ipinfo.io. Optional, but required if you expect to serve a large number of tests
# DISABLE_IPINFO: If set to true, ISP info and distance will not be fetched from ipinfo.io. Default: value: false
# DISTANCE: When DISABLE_IPINFO is set to false, this specifies how the distance from the server is measured. Can be either km for kilometers, mi for miles, or an empty string to disable distance measurement. Default value: km
# If telemetry is enabled, a stats page will be available at http://your.server/results/stats.php, but a password must be specified.

TITLE   				?= ds.LibreSpeed
TELEMETRY       		:= true
ENABLE_ID_OBFUSCATION   := true
REDACT_IP_ADDRESSES   	:= true
PASSWORD       			:= "password123!"
EMAIL 					:= "testemail@gmail1.com"
IPINFO_APIKEY   		:= true
DISABLE_IPINFO      	:= false
DISTANCE 				:= km
MODE					:= standalone
PORT					:= 8080

WORKING_DIR 			:= $(shell pwd)

.DEFAULT_GOAL := help

docker-run: ## Start the docker container available at  http://localhost:80
	docker run --name $(TITLE) -e MODE=$(MODE) -e TELEMETRY=$(TELEMETRY) -e ENABLE_ID_OBFUSCATION=$(ENABLE_ID_OBFUSCATION) -e REDACT_IP_ADDRESSES=$(REDACT_IP_ADDRESSES) -e DISTANCE=$(DISTANCE) -e EMAIL=$(EMAIL) -e DISABLE_IPINFO=$(DISABLE_IPINFO) -e PASSWORD=$(PASSWORD) -p $(PORT):80 --rm -it  adolfintel/speedtest

	@echo " "
	@echo "------------------------------------------"
	@echo "$(TITLE) is available on http://localhost:$(PORT)"
	@echo "------------------------------------------"
	@echo " "


# A help target including self-documenting targets (see the awk statement)
define HELP_TEXT
Usage: make [TARGET]... [MAKEVAR1=SOMETHING]...

Available targets:
endef
export HELP_TEXT
help: ## This help target
	@cat .banner
	@echo " "
	@echo " "
	@echo "Start $(TITLE) docker server"
	@echo " "
	@echo " "
	@echo "$$HELP_TEXT"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / \
		{printf "\033[36m%-30s\033[0m  %s\n", $$1, $$2}' $(MAKEFILE_LIST)

