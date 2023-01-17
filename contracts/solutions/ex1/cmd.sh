if [ "$1" == "deploy" ]; then 
    echo "deploying..."
    starknet deploy --inputs 1 1 1274519388635697963204543407605438159849675014318520616686163352039693617685 --network alpha-goerli --class_hash $2
elif [ "$1" == "declare" ]; then 
    echo "declaring..."
    starknet declare --contract  ./ERC721_compiled.json --network alpha-goerli 
else 
    echo "compiling..."
    starknet-compile ./ERC721.cairo --output ./ERC721_compiled.json
fi
