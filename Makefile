-include .env

.PHONY: all test clean deploy fund help install snapshot format anvil zktest

all: clean remove install update build

# Clean the repo
clean  :; forge clean

# Remove modules
remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"


# Update Dependencies
update:; forge update

build:; forge build


test :; forge test

snapshot :; forge snapshot

format :; forge fmt
