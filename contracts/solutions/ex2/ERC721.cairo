%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin, SignatureBuiltin
from starkware.cairo.common.uint256 import (Uint256, uint256_add)
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

struct Animal {
    sex: felt,
    legs: felt,
    wings: felt,
}

@storage_var
func next_id() -> (next_id: Uint256) {
}

@storage_var
func animals(token_id: Uint256) -> (animal: Animal) {
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

    return (token_id,);
}



@view
func get_animal_characteristics{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(token_id: Uint256) -> (sex: felt, legs: felt, wings: felt) {
    let (animal) = animals.read(token_id);
    return (animal.sex, animal.legs, animal.wings);
}
