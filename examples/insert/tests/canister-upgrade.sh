#!/bin/bash

printf "[TEST] 🤖 Canister upgrade\n\n"

CANISTER_ID_CAP_SERVICE=$1
CANISTER_ID_CAP_MOTOKO_INSERT_EXAMPLE=$2

dfx canister install --all --mode upgrade

printf "\n\n"

GET_TOKEN_CONTRACT_RESPONSE=$(dfx canister call "$CANISTER_ID_CAP_SERVICE" get_token_contract_root_bucket "(record { canister=(principal \"$CANISTER_ID_CAP_MOTOKO_INSERT_EXAMPLE\"); witness=(false:bool)})")

TOKEN_CONTRACT=$(echo "$GET_TOKEN_CONTRACT_RESPONSE" | pcre2grep -o1 'principal "(.*?)"')

printf "[TEST] 🤖 Token contract root, get_transactions result\n\n"

dfx canister call "$TOKEN_CONTRACT" get_transactions "( record { witness = (false:bool) } )"