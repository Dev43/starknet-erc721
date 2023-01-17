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

# Contract class hash: 0x79dbf2cd2a78bb45aea880f2190bde2e71e42573b62c3f94bdb75a37159c703

# Contract address: 0x05403de672bbb15d13501ae0dbc8adff1e1be2e09b3c9fe7710a1a07f54181eb