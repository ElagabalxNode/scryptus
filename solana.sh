#!/bin/bash
#set -x -e

vote_acc="/home/solana/vote-account-keypair.json"
key_acc="/home/solana/validator-keypair.json"
author="/home/solana/authorized-withdrawer-keypair.json"
wallet="14i1Raw3yrWJvph1a8C9uEMK2xNutY2mZAhQTCi4Ed4a"

while :
do
echo "checking Epoch Progress"
epoch="$(solana epoch-info | grep -o "......%" | tr -d [=%=][:space:])"
echo "$epoch %"
num2=0.8
echo "Not yeat"
sleep 5

if (( $(echo "$epoch > $num2" |bc -l) )); then
continue
fi
echo "Let's go!"
echo "Withdraw from vote"
solana -um withdraw-from-vote-account "$vote_acc" "$key_acc" ALL -k "$author"
sleep 35
echo "Checking balance"

    balance="$(solana balance | tr -d [:upper:][:space:])"
    echo "$balance SOL"
    comission=1.75
    reward=$(echo $balance-$comission | bc -l)
    echo "$reward"

sleep 35
echo "Transfer reward"
solana -um transfer "$wallet" --from $key_acc -k "$author" "$reward"

done