if [ "$1" == "deploy" ]; then 
    echo "deploying..."
    starknet deploy --inputs 1 1 --network alpha-goerli --class_hash $2
elif [ "$1" == "declare" ]; then 
    echo "declaring..."
    starknet declare --contract  ./ERC721_compiled.json --network alpha-goerli 
else 
    echo "compiling..."
    starknet-compile ./ERC721.cairo --output ./ERC721_compiled.json
fi


#  Legs: 8, Sex: 1, Wings:1, Rank: 81

# Class hash 0x65bd529d82cc456d77ceb4774b70cbd83c301def821828f10eb159d4f3aa976

# Contract 0x075a33ef21ccb56a9e5db232eea3919e0b3c0e369f3355a17600bcc44c8cf4e4