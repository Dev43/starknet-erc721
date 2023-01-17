if [ "$1" == "deploy" ]; then 
    echo "deploying..."
    starknet deploy --inputs 1 1 361958816396474883452031563054282316433373339603650974221110346970974921578 --network alpha-goerli --class_hash $2
elif [ "$1" == "declare" ]; then 
    echo "declaring..."
    starknet declare --contract  ./ERC721_compiled.json --network alpha-goerli 
else 
    echo "compiling..."
    export CAIRO_PATH="/home/dev43/blockchain/dev43/starknet-bootcamp/erc721/starknet-erc721"
    starknet-compile ./ERC721.cairo --output ./ERC721_compiled.json
fi


# Legs: 8, Sex: 1, Wings:1, Rank: 81

# Contract class hash: 0x16a0faea1572a33790b92ea8fa6ab7c02f5818063e4bf81d0c356c4c6fffbba

# Contract address: 0x01621145c46ceca515e8fdeca231f41392e41744cadbe129ec26460a4ff163a3