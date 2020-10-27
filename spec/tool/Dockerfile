FROM ubuntu:xenial

RUN apt-get -y update
RUN apt-get install -y python-software-properties 
RUN apt-get install -y software-properties-common

RUN add-apt-repository ppa:bitcoin/bitcoin
RUN apt-get update
RUN apt-get install -y bitcoind
RUN apt-get install -y telnet net-tools less

RUN mkdir ~/.bitcoin
RUN echo "rpcuser=test" >> /root/.bitcoin/bitcoin.conf 
RUN echo "rpcpassword=test" >> /root/.bitcoin/bitcoin.conf 
RUN echo "alias rt='bitcoin-cli -regtest'" >> ~/.bashrc

EXPOSE 18444 18443
