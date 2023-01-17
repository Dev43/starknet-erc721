%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin, SignatureBuiltin
from starkware.cairo.common.uint256 import (Uint256, uint256_add, uint256_sub)
from starkware.starknet.common.syscalls import (get_caller_address, get_contract_address)
from openzeppelin.token.erc721.library import ERC721

@contract_interface
namespace IExerciseSolution {
    // Breeding function
    func is_breeder(account: felt) -> (is_approved: felt) {
    }
    func registration_price() -> (price: Uint256) {
    }
    func register_me_as_breeder() -> (is_added: felt) {
    }
    func declare_animal(sex: felt, legs: felt, wings: felt) -> (token_id: Uint256) {
    }
    func get_animal_characteristics(token_id: Uint256) -> (sex: felt, legs: felt, wings: felt) {
    }
    func token_of_owner_by_index(account: felt, index: felt) -> (token_id: Uint256) {
    }
    func declare_dead_animal(token_id: Uint256) {
    }
}

@contract_interface
namespace IERC20 {
    func name() -> (name: felt) {
    }

    func symbol() -> (symbol: felt) {
    }

    func decimals() -> (decimals: felt) {
    }

    func totalSupply() -> (totalSupply: Uint256) {
    }

    func balanceOf(account: felt) -> (balance: Uint256) {
    }

    func allowance(owner: felt, spender: felt) -> (remaining: Uint256) {
    }

    func transfer(recipient: felt, amount: Uint256) -> (success: felt) {
    }

    func transferFrom(sender: felt, recipient: felt, amount: Uint256) -> (success: felt) {
    }

    func approve(spender: felt, amount: Uint256) -> (success: felt) {
    }
}


struct Animal {
    sex: felt,
    legs: felt,
    wings: felt,
}

@storage_var
func next_id() -> (next_id: Uint256) {
}

@storage_var
func _is_breeder(account: felt) -> (is_approved: felt) {
}

@storage_var
func animals(token_id: Uint256) -> (animal: Animal) {
}

@storage_var
func owned_tokens(account: felt, index: felt) -> (token_id: Uint256) {
}

// gives us the index for this token id
@storage_var
func owned_tokens_index(token_id: Uint256) -> (token_index: felt) {
}

@storage_var
func total_ids(account: felt) -> (total: felt) {
}


//
// Constructor
//

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    name: felt, symbol: felt
) {
    ERC721.initializer(name, symbol);
 
    let token_id: Uint256 = Uint256(1, 0);
    next_id.write(token_id);

    declare_animal_for(sex=1, legs=8, wings=1, for=0x2d15a378e131b0a9dc323d0eae882bfe8ecc59de0eb206266ca236f823e0a15);
    
    return ();
}

//
// Getters
//

@view
func name{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (name: felt) {
    let (name) = ERC721.name();
    return (name,);
}

@view
func symbol{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (symbol: felt) {
    let (symbol) = ERC721.symbol();
    return (symbol,);
}

@view
func balanceOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(owner: felt) -> (
    balance: Uint256
) {
    let (balance: Uint256) = ERC721.balance_of(owner);
    return (balance,);
}

@view
func ownerOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    token_id: Uint256
) -> (owner: felt) {
    let (owner: felt) = ERC721.owner_of(token_id);
    return (owner,);
}

@view
func getApproved{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    token_id: Uint256
) -> (approved: felt) {
    let (approved: felt) = ERC721.get_approved(token_id);
    return (approved,);
}

@view
func isApprovedForAll{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    owner: felt, operator: felt
) -> (is_approved: felt) {
    let (is_approved: felt) = ERC721.is_approved_for_all(owner, operator);
    return (is_approved,);
}

//
// Externals
//

@external
func approve{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    to: felt, token_id: Uint256
) {
    ERC721.approve(to, token_id);
    return ();
}

@external
func setApprovalForAll{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    operator: felt, approved: felt
) {
    ERC721.set_approval_for_all(operator, approved);
    return ();
}

@external
func transferFrom{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    _from: felt, to: felt, token_id: Uint256
) {
    ERC721.transfer_from(_from, to, token_id);
    return ();
}

@external
func safeTransferFrom{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    _from: felt, to: felt, token_id: Uint256, data_len: felt, data: felt*
) {
    ERC721.safe_transfer_from(_from, to, token_id, data_len, data);
    return ();
}

//////
// Solution
/////

@external
func declare_animal{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(sex: felt, legs: felt, wings: felt) -> (token_id: Uint256) {
    let (sender_address) = get_caller_address();

    let (token_id) = declare_animal_for(sex, legs, wings, sender_address);

    return (token_id,);
}

func declare_animal_for{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(sex: felt, legs: felt, wings: felt, for: felt) -> (token_id: Uint256) {

    let animal_instance = Animal(sex=sex, legs=legs, wings=wings);
    let (token_id) = next_id.read();

    let (next, _) = uint256_add(token_id, Uint256(1,0));
    next_id.write(next);

    animals.write(token_id, animal_instance);
    
    ERC721._mint(for, token_id);

    // we increase the total number of ids
    let (t) = total_ids.read(for);
    total_ids.write(for, t + 1);
    // we add the id to our mapping at the t index
    owned_tokens.write(for, t, token_id);
    // we add to the token index
    owned_tokens_index.write(token_id, t);

    return (token_id,);
}



@view
func get_animal_characteristics{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(token_id: Uint256) -> (sex: felt, legs: felt, wings: felt) {
    let (animal) = animals.read(token_id);
    return (animal.sex, animal.legs, animal.wings);
}

@external 
func declare_dead_animal{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(token_id: Uint256) {
    let (sender_address) = get_caller_address();

    ERC721._burn(token_id);
    let zero_animal = Animal(sex=0, legs=0, wings=0);
    animals.write(token_id, zero_animal);
    
    let (t) = total_ids.read(sender_address);
    // reduce total ids for sender by 1
    total_ids.write(sender_address, t - 1);
    // we get the token index
    let (token_index) = owned_tokens_index.read(token_id);
    // we get the last token index
    let last_token_index = t - 1;

    let (last_token) = owned_tokens.read(sender_address, last_token_index);

    owned_tokens.write(sender_address, token_index, last_token);

    owned_tokens_index.write(token_id, 0);
    owned_tokens_index.write(last_token, token_index);

    return ();
}

@view
func token_of_owner_by_index{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(account: felt, index: felt) -> (token_id: Uint256) {
    let (token_id) = owned_tokens.read(account, index);
    return (token_id,);
}

@view
func is_breeder{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(account: felt) -> (is_approved: felt) {
    let is_approved = _is_breeder.read(account);
    return is_approved;
}

@external
func register_me_as_breeder{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}() -> (is_added: felt) {
    let (me) = get_contract_address();
    let (sender_address) = get_caller_address();
    // let (reg_price) = registration_price();
    IERC20.transferFrom(contract_address=0x52ec5de9a76623f18e38c400f763013ff0b3ff8491431d7dc0391b3478bf1f3,sender=sender_address, recipient=me, amount=Uint256(1,0));
    _is_breeder.write(sender_address, 1);
    return (1,);
}

@external 
func registration_price{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}() -> (price: Uint256) {
    return (Uint256(1,0),);
}