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


# Legs: 8, Sex: 1, Wings:1, Rank: 81

# Contract class hash: 0x162d6eac6c05226fb42e7eef2a8648cfccaec5ba05a954c2e003843f59b012c

# Contract address: 0x0127a0bf572b5fd6640d18db58c95fca089ee2fd86edf8860b8f8a697ab5abe5