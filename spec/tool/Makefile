HOST_NAME=bitcoind
DOCKER_RUN=docker run -t
DOCKER=$(DOCKER_RUN) -p 18443:18443 --name=bitcoind --hostname=$(HOST_NAME)

IMG=bitcoind-regtest

RUN_DAEMON=bitcoind -regtest -rpcbind=0.0.0.0 -rpcallowip=0.0.0.0/0 -rpcuser=test -rpcpassword=test -printtoconsole 		
RUN_SHELL=bash
RUN_CLI=bitcoin-cli --regtest 
CONTAINER_ID=$(shell docker ps -aqf "name=$(HOST_NAME)") 

build:
	@docker build -t $(IMG) .

start: rm build 
	@$(DOCKER) -d=true $(IMG) $(RUN_DAEMON) > /dev/null


shell: 
	@docker exec -it $(CONTAINER_ID) $(RUN_SHELL)

rm:
	-docker rm -f $(HOST_NAME)

