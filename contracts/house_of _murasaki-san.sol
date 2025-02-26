

// SPDX-License-Identifier: MIT
pragma solidity =0.8.13;


// 241212
// House of Murasaki-san ver. 0.1.27


//===Import==================================================================================================================



// for remix

// openzeppelin v4.8 for solidity 0.8.13

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.8/contracts/security/ReentrancyGuard.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.8/contracts/security/Pausable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.8/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.8/contracts/utils/structs/EnumerableSet.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.8/contracts/utils/Base64.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.8/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.8/contracts/token/ERC721/IERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.8/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.8/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.8/contracts/token/ERC721/IERC721Receiver.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.8/contracts/utils/Address.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.8/contracts/utils/Context.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.8/contracts/utils/Strings.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.8/contracts/utils/introspection/ERC165.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.8/contracts/utils/introspection/IERC165.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.8/contracts/token/ERC721/utils/ERC721Holder.sol";
import "github.com/AstarNetwork/astarbase/contract/example/IAstarBase.sol";

// for ERC6551 from openzeppelin
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.8/contracts/interfaces/IERC1271.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.8/contracts/utils/cryptography/SignatureChecker.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.8/contracts/utils/Create2.sol";

// for ERC6551 from https://github.com/BuildBearLabs/Tutorials
import "github.com/BuildBearLabs/Tutorials/ERC-6551/contracts/lib/Bytecode.sol";
import "github.com/BuildBearLabs/Tutorials/ERC-6551/contracts/interface/IERC6551Account.sol";
import "github.com/BuildBearLabs/Tutorials/ERC-6551/contracts/interface/IERC6551Registry.sol";




// for solc, 0.8.13
/*
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@astarbase/contract/example/IAstarBase.sol";

import "@openzeppelin/contracts/interfaces/IERC1271.sol";
import "@openzeppelin/contracts/utils/cryptography/SignatureChecker.sol";
import "@openzeppelin/contracts/utils/Create2.sol";

import "@Tutorials/ERC-6551/contracts/lib/Bytecode.sol";
import "@Tutorials/ERC-6551/contracts/interface/IERC6551Account.sol";
import "@Tutorials/ERC-6551/contracts/interface/IERC6551Registry.sol";
*/


//===Basic==================================================================================================================


//---IERC2665

// @dev of HoM: ERC-2665
// @dev of HoM: https://github.com/ethereum/EIPs/issues/2665

/// @title ERC-2665 NFT Transfer Fee Extension
/// @dev See https://github.com/ethereum/EIPs/issues/2665
///  Note: the ERC-165 identifier for this interface is 0x509ffea4.
///  Note: you must also implement the ERC-165 identifier of ERC-721, which is 0x80ac58cd.
interface IERC2665 /* is ERC165, is ERC721 but overide it's Design by contract specifications */ {
    /// @dev This emits when ownership of any NFT changes by any mechanism.
    ///  This event emits when NFTs are created (`from` == 0) and destroyed
    ///  (`to` == 0). Exception: during contract creation, any number of NFTs
    ///  may be created and assigned without emitting Transfer. At the time of
    ///  any transfer, the approved address for that NFT (if any) is reset to none.
    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);

    /// @dev This emits when the approved address for an NFT is changed or
    ///  reaffirmed. The zero address indicates there is no approved address.
    ///  When a Transfer event emits, this also indicates that the approved
    ///  address for that NFT (if any) is reset to none.
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);

    /// @dev This emits when an operator is enabled or disabled for an owner.
    ///  The operator can manage all NFTs of the owner.
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    /// @notice Count all NFTs assigned to an owner
    /// @dev NFTs assigned to the zero address are considered invalid, and this
    ///  function throws for queries about the zero address.
    /// @param _owner An address for whom to query the balance
    /// @return The number of NFTs owned by `_owner`, possibly zero
    function balanceOf(address _owner) external view returns (uint256);

    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an NFT
    /// @return The address of the owner of the NFT
    function ownerOf(uint256 _tokenId) external view returns (address);

    /// @notice Transfers the ownership of an NFT from one address to another address
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `msg.value` < `getTransferFee(_tokenId)`.
    ///  If the fee is not to be paid in ETH, then token publishers SHOULD provide a way to pay the
    ///  fee when calling this function or it's overloads, and throwing if said fee is not paid.
    ///  Throws if `_to` is the zero address. Throws if `_tokenId` is not a valid NFT.
    ///  When transfer is complete, this function checks if `_to` is a smart
    ///  contract (code size > 0). If so, it calls `onERC2665Received` on `_to`
    ///  and throws if the return value is not
    ///  `bytes4(keccak256("onERC2665Received(address,address,uint256,bytes)"))`.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    /// @param data Additional data with no specified format, sent in call to `_to`
    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata data) external payable;

    /// @notice Transfers the ownership of an NFT from one address to another address
    /// @dev This works identically to the other function with an extra data parameter,
    ///  except this function just sets data to "".
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;

    /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
    ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
    ///  THEY MAY BE PERMANENTLY LOST
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT. Throws if `msg.value` < `getTransferFee(_tokenId)`.
    ///  If the fee is not to be paid in ETH, then token publishers SHOULD provide a way to pay the
    ///  fee when calling this function and throw if said fee is not paid.
    ///  Throws if `_to` is the zero address. Throws if `_tokenId` is not a valid NFT.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    function transferFrom(address _from, address _to, uint256 _tokenId) external payable;

    /// @notice Change or reaffirm the approved address for an NFT
    /// @dev The zero address indicates there is no approved address.
    ///  Throws unless `msg.sender` is the current NFT owner, or an authorized
    ///  operator of the current owner. After a successful call and if
    ///  `msg.value == getTransferFee(_tokenId)`, then a subsequent atomic call to
    ///  `getTransferFee(_tokenId)` would eval to 0. If the fee is not to be paid in ETH,
    ///  then token publishers MUST provide a way to pay the fee when calling this function,
    ///  and throw if the fee is not paid.
    /// @param _approved The new approved NFT controller
    /// @param _tokenId The NFT to approve
    function approve(address _approved, uint256 _tokenId) external payable;

    /// @notice Enable or disable approval for a third party ("operator") to manage
    ///  all of `msg.sender`'s assets
    /// @dev Emits the ApprovalForAll event. The contract MUST allow
    ///  multiple operators per owner.
    /// @param _operator Address to add to the set of authorized operators
    /// @param _approved True if the operator is approved, false to revoke approval
    function setApprovalForAll(address _operator, bool _approved) external;

    /// @notice Get the approved address for a single NFT
    /// @dev Throws if `_tokenId` is not a valid NFT.
    /// @param _tokenId The NFT to find the approved address for
    /// @return The approved address for this NFT, or the zero address if there is none
    function getApproved(uint256 _tokenId) external view returns (address);

    /// @notice Query if an address is an authorized operator for another address
    /// @param _owner The address that owns the NFTs
    /// @param _operator The address that acts on behalf of the owner
    /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
    function isApprovedForAll(address _owner, address _operator) external view returns (bool);

    /// @notice Query what is the transfer fee for a specific token
    /// @dev If a call would returns 0, then any subsequent calls witht the same argument
    /// must also return 0 until the Transfer event has been emitted.
    /// @param _tokenId The NFT to find the Transfer Fee amount for
    /// @return The amount of Wei that need to be sent along a call to a transfer function
    function getTransferFee(uint256 _tokenId) external view returns (uint256);

    /// @notice Query what is the transfer fee for a specific token if the fee is to be paid
    /// @dev If a call would returns 0, then any subsequent calls with the same arguments
    /// must also return 0 until the Transfer event has been emitted. If _currencySymbol == 'ETH',
    /// then this function must return the same result as if `getTransferFee(uint256 _tokenId)` was called.
    /// @param _tokenId The NFT to find the Transfer Fee amount for
    /// @param _currencySymbol The currency in which the fee is to be paid
    /// @return The amount of Currency that need to be sent along a call to a transfer function
    function getTransferFee(uint256 _tokenId, string calldata _currencySymbol) external view returns (uint256);
}


//---IERC2665Metadata

// @dev of HoM: IERC2665Metadata
// @dev of HoM: The following code is based on the IERC721Metadata.sol code from OpenZeppelin.
// @dev of HoM: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol

/**
 * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
 * @dev See https://eips.ethereum.org/EIPS/eip-721
 */
interface IERC2665Metadata is IERC2665 { //IERC721Metadata is IERC721 {
    /**
     * @dev Returns the token collection name.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the token collection symbol.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
     */
    function tokenURI(uint256 tokenId) external view returns (string memory);
}


//---ERC2665

// @dev of HoM: ERC2665 is an extension of ERC721 that adds the payable modifier 
// @dev of HoM: to the "approve", "transferFrom", and "safeTransferFrom" functions. 
// @dev of HoM: The "supportsInterface" function has alose been modified to include 
// @dev of HoM: the IERC2665 interface. Additionally, a new function called "getTransferFee" 
// @dev of HoM: has been added to match the IERC2665 interface. "ERC721.ownerOf(tokenId)"
// @dev of HoM: codes have also been replaced to "ERC2665.ownerOf(tokenId)". 
// @dev of HoM: The following code is based on the ERC721.sol code from OpenZeppelin:
// @dev of HoM: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol

/**
 * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
 * the Metadata extension, but not including the Enumerable extension, which is available separately as
 * {ERC721Enumerable}.
 */
contract ERC2665 is Context, ERC165, IERC2665, IERC2665Metadata { // ERC721 is Context, ERC165, IERC721, IERC721Metadata {
    using Address for address;
    using Strings for uint256;

    // Token name
    string private _name;

    // Token symbol
    string private _symbol;

    // Mapping from token ID to owner address
    mapping(uint256 => address) private _owners;

    // Mapping owner address to token count
    mapping(address => uint256) private _balances;

    // Mapping from token ID to approved address
    mapping(uint256 => address) private _tokenApprovals;

    // Mapping from owner to operator approvals
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    /**
     * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    //function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {    //@dev of HoM: modified
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId ||
            interfaceId == type(IERC2665).interfaceId ||            //@dev of HoM: added
            interfaceId == type(IERC2665Metadata).interfaceId ||    //@dev of HoM: added
            super.supportsInterface(interfaceId);
    }

    /**
     * @dev See {IERC721-balanceOf}.
     */
    function balanceOf(address owner) public view virtual override returns (uint256) {
        require(owner != address(0), "ERC721: address zero is not a valid owner");
        return _balances[owner];
    }

    /**
     * @dev See {IERC721-ownerOf}.
     */
    function ownerOf(uint256 tokenId) public view virtual override returns (address) {
        address owner = _ownerOf(tokenId);
        require(owner != address(0), "ERC721: invalid token ID");
        return owner;
    }

    /**
     * @dev See {IERC721Metadata-name}.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev See {IERC721Metadata-symbol}.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        _requireMinted(tokenId);

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
    }

    /**
     * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
     * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
     * by default, can be overridden in child contracts.
     */
    function _baseURI() internal view virtual returns (string memory) {
        return "";
    }

    /**
     * @dev See {IERC721-approve}.
     */
    function approve(address to, uint256 tokenId) public virtual override payable {
        //address owner = ERC721.ownerOf(tokenId);
        address owner = ERC2665.ownerOf(tokenId);   //@dev of HoM: modified
        require(to != owner, "ERC721: approval to current owner");

        require(
            _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
            "ERC721: approve caller is not token owner or approved for all"
        );

        _approve(to, tokenId);
    }

    /**
     * @dev See {IERC721-getApproved}.
     */
    function getApproved(uint256 tokenId) public view virtual override returns (address) {
        _requireMinted(tokenId);

        return _tokenApprovals[tokenId];
    }

    /**
     * @dev See {IERC721-setApprovalForAll}.
     */
    function setApprovalForAll(address operator, bool approved) public virtual override {
        _setApprovalForAll(_msgSender(), operator, approved);
    }

    /**
     * @dev See {IERC721-isApprovedForAll}.
     */
    function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    /**
     * @dev See {IERC721-transferFrom}.
     */
    function transferFrom(address from, address to, uint256 tokenId) public virtual override payable {
        //solhint-disable-next-line max-line-length
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");

        _transfer(from, to, tokenId);
    }

    /**
     * @dev See {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override payable {
        safeTransferFrom(from, to, tokenId, "");
    }

    /**
     * @dev See {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public virtual override payable {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
        _safeTransfer(from, to, tokenId, data);
    }

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * `data` is additional data, it has no specified format and it is sent in call to `to`.
     *
     * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
     * implement alternative mechanisms to perform token transfer, such as signature-based.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function _safeTransfer(address from, address to, uint256 tokenId, bytes memory data) internal virtual {
        _transfer(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
    }

    /**
     * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
     */
    function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
        return _owners[tokenId];
    }

    /**
     * @dev Returns whether `tokenId` exists.
     *
     * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
     *
     * Tokens start existing when they are minted (`_mint`),
     * and stop existing when they are burned (`_burn`).
     */
    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _ownerOf(tokenId) != address(0);
    }

    /**
     * @dev Returns whether `spender` is allowed to manage `tokenId`.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
        //address owner = ERC721.ownerOf(tokenId);
        address owner = ERC2665.ownerOf(tokenId);   //@dev of HoM: modified
        return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
    }

    /**
     * @dev Safely mints `tokenId` and transfers it to `to`.
     *
     * Requirements:
     *
     * - `tokenId` must not exist.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function _safeMint(address to, uint256 tokenId) internal virtual {
        _safeMint(to, tokenId, "");
    }

    /**
     * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
     * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
     */
    function _safeMint(address to, uint256 tokenId, bytes memory data) internal virtual {
        _mint(to, tokenId);
        require(
            _checkOnERC721Received(address(0), to, tokenId, data),
            "ERC721: transfer to non ERC721Receiver implementer"
        );
    }

    /**
     * @dev Mints `tokenId` and transfers it to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
     *
     * Requirements:
     *
     * - `tokenId` must not exist.
     * - `to` cannot be the zero address.
     *
     * Emits a {Transfer} event.
     */
    function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");

        _beforeTokenTransfer(address(0), to, tokenId, 1);

        // Check that tokenId was not minted by `_beforeTokenTransfer` hook
        require(!_exists(tokenId), "ERC721: token already minted");

        unchecked {
            // Will not overflow unless all 2**256 token ids are minted to the same owner.
            // Given that tokens are minted one by one, it is impossible in practice that
            // this ever happens. Might change if we allow batch minting.
            // The ERC fails to describe this case.
            _balances[to] += 1;
        }

        _owners[tokenId] = to;

        emit Transfer(address(0), to, tokenId);

        _afterTokenTransfer(address(0), to, tokenId, 1);
    }

    /**
     * @dev Destroys `tokenId`.
     * The approval is cleared when the token is burned.
     * This is an internal function that does not check if the sender is authorized to operate on the token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     *
     * Emits a {Transfer} event.
     */
    function _burn(uint256 tokenId) internal virtual {
        //address owner = ERC721.ownerOf(tokenId);
        address owner = ERC2665.ownerOf(tokenId);    //@dev of HoM: modified

        _beforeTokenTransfer(owner, address(0), tokenId, 1);

        // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
        //owner = ERC721.ownerOf(tokenId);
        owner = ERC2665.ownerOf(tokenId);    //@dev of HoM: modified

        // Clear approvals
        delete _tokenApprovals[tokenId];

        unchecked {
            // Cannot overflow, as that would require more tokens to be burned/transferred
            // out than the owner initially received through minting and transferring in.
            _balances[owner] -= 1;
        }
        delete _owners[tokenId];

        emit Transfer(owner, address(0), tokenId);

        _afterTokenTransfer(owner, address(0), tokenId, 1);
    }

    /**
     * @dev Transfers `tokenId` from `from` to `to`.
     *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     *
     * Emits a {Transfer} event.
     */
    function _transfer(address from, address to, uint256 tokenId) internal virtual {
        //require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
        require(ERC2665.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner"); //@dev of HoM: modified
        require(to != address(0), "ERC721: transfer to the zero address");

        _beforeTokenTransfer(from, to, tokenId, 1);

        // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
        //require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
        require(ERC2665.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");  //@dev of HoM: modified

        // Clear approvals from the previous owner
        delete _tokenApprovals[tokenId];

        unchecked {
            // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
            // `from`'s balance is the number of token held, which is at least one before the current
            // transfer.
            // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
            // all 2**256 token ids to be minted, which in practice is impossible.
            _balances[from] -= 1;
            _balances[to] += 1;
        }
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);

        _afterTokenTransfer(from, to, tokenId, 1);
    }

    /**
     * @dev Approve `to` to operate on `tokenId`
     *
     * Emits an {Approval} event.
     */
    function _approve(address to, uint256 tokenId) internal virtual {
        _tokenApprovals[tokenId] = to;
        //emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
        emit Approval(ERC2665.ownerOf(tokenId), to, tokenId);    //@dev of HoM: modified
    }

    /**
     * @dev Approve `operator` to operate on all of `owner` tokens
     *
     * Emits an {ApprovalForAll} event.
     */
    function _setApprovalForAll(address owner, address operator, bool approved) internal virtual {
        require(owner != operator, "ERC721: approve to caller");
        _operatorApprovals[owner][operator] = approved;
        emit ApprovalForAll(owner, operator, approved);
    }

    /**
     * @dev Reverts if the `tokenId` has not been minted yet.
     */
    function _requireMinted(uint256 tokenId) internal view virtual {
        require(_exists(tokenId), "ERC721: invalid token ID");
    }

    /**
     * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
     * The call is not executed if the target address is not a contract.
     *
     * @param from address representing the previous owner of the given token ID
     * @param to target address that will receive the tokens
     * @param tokenId uint256 ID of the token to be transferred
     * @param data bytes optional data to send along with the call
     * @return bool whether the call correctly returned the expected magic value
     */
    function _checkOnERC721Received(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) private returns (bool) {
        if (to.isContract()) {
            try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
                return retval == IERC721Receiver.onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("ERC721: transfer to non ERC721Receiver implementer");
                } else {
                    /// @solidity memory-safe-assembly
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }

    /**
     * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
     * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
     *
     * Calling conditions:
     *
     * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
     * - When `from` is zero, the tokens will be minted for `to`.
     * - When `to` is zero, ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     * - `batchSize` is non-zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize) internal virtual {}

    /**
     * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
     * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
     *
     * Calling conditions:
     *
     * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
     * - When `from` is zero, the tokens were minted for `to`.
     * - When `to` is zero, ``from``'s tokens were burned.
     * - `from` and `to` are never both zero.
     * - `batchSize` is non-zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _afterTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize) internal virtual {}

    /**
     * @dev Unsafe write access to the balances, used by extensions that "mint" tokens using an {ownerOf} override.
     *
     * WARNING: Anyone calling this MUST ensure that the balances remain consistent with the ownership. The invariant
     * being that for any address `a` the value returned by `balanceOf(a)` must be equal to the number of tokens such
     * that `ownerOf(tokenId)` is `a`.
     */
    // solhint-disable-next-line func-name-mixedcase
    function __unsafe_increaseBalance(address account, uint256 amount) internal {
        _balances[account] += amount;
    }

    //@dev of HoM: add the functions to match IERC2665
    //@dev of HoM: these functions are overrided after inheritance

    function getTransferFee(uint256) external view virtual returns (uint256) {
        return 0;
    }

    function getTransferFee(uint256, string calldata) external view virtual returns (uint256) {
        return 0;
    }
}



//---SoulBoundBadge

// @dev of HoM: SBB is ERC721 but non-transferable, only one per wallet, burnable

abstract contract SoulBoundBadge is ERC721 {
    
    // tokens and tokenOf getter
    mapping(address => uint) private _tokens;
    function tokenOf(address _owner) public view returns (uint) {
        require(_owner != address(0));
        return _tokens[_owner];
    }

    // next_token
    uint public next_token = 1;
    
    // non-transferable
    function _beforeTokenTransfer(address from, address to, uint256, uint256) internal pure override {
        require(from == address(0) || to == address(0), "This a Soulbound token. It cannot be transferred. It can only be burned by the token owner.");
    }
    
    // only one per wallet, burnable
    function _afterTokenTransfer(address from, address to, uint256 tokenId, uint256) internal override {
        // when mint
        if ( from == address(0) ) {
            require(_tokens[to] == 0, "Owner already has a token");
            _tokens[to] = tokenId;
            next_token++;
        // when burn
        } else if ( to == address(0) ) {
            _tokens[from] = 0;
        }
    }
}


//===All-in==================================================================================================================


//---Murasakisan


interface IMurasakisan {

    // Murasaki-san ID of the wallet
    function summoner   (address _wallet) external view returns (uint);

    // Basic informations of Murasaki-san
    function class  (address _wallet) external view returns (uint);
    function age    (address _wallet) external view returns (uint);
    function name   (address _wallet) external view returns (string memory);
    function level  (address _wallet) external view returns (uint);

    // Character of Murasaki-san
    function birthplace  (address _wallet) external view returns (string memory);
    function character   (address _wallet) external view returns (string memory);
    function weakpoint   (address _wallet) external view returns (string memory);
    function scent       (address _wallet) external view returns (string memory);
    function personality (address _wallet) external view returns (string memory);
    function flower      (address _wallet) external view returns (string memory);

    // Address of the house
    function street      (address _wallet) external view returns (string memory);
    function city        (address _wallet) external view returns (string memory);

    // Status
    function strength       (address _wallet) external view returns (uint);
    function dexterity      (address _wallet) external view returns (uint);
    function intelligence   (address _wallet) external view returns (uint);
    function luck           (address _wallet) external view returns (uint);

    // Status adjusted for item effects
    function strength_withItems      (address _wallet) external view returns (uint);
    function dexterity_withItems     (address _wallet) external view returns (uint);
    function intelligence_withItems  (address _wallet) external view returns (uint);
    function luck_withItems          (address _wallet) external view returns (uint);
    function luck_withItems_withDice (address _wallet) external view returns (uint);
    
    // Current parameters of Murasaki-san
    function satiety    (address _wallet) external view returns (uint);
    function happy      (address _wallet) external view returns (uint);
    function exp        (address _wallet) external view returns (uint);
    function coin       (address _wallet) external view returns (uint);
    function leaf       (address _wallet) external view returns (uint);
    function fluffy     (address _wallet) external view returns (uint);
    function score      (address _wallet) external view returns (uint);

    // Total counts
    function total_exp_gained       (address _wallet) external view returns (uint);
    function total_coin_mined       (address _wallet) external view returns (uint);
    function total_leaf_farmed      (address _wallet) external view returns (uint);
    function total_item_crafted     (address _wallet) external view returns (uint);
    function total_fluffy_received  (address _wallet) external view returns (uint);
    function total_feeding_count    (address _wallet) external view returns (uint);
    function total_grooming_count   (address _wallet) external view returns (uint);
    function total_neglect_count    (address _wallet) external view returns (uint);
    function total_critical_count   (address _wallet) external view returns (uint);

    // Other parameters
    function not_petrified  (address _wallet) external view returns (uint);
    function isActive       (address _wallet) external view returns (uint);
    function inHouse        (address _wallet) external view returns (uint);
    
    // Achievements
    function countOf_achievement            (address _wallet) external view returns (uint);
    function scoreOf_achievement_onChain    (address _wallet) external view returns (uint);

    // Practice
    function clarinet_level  (address _wallet) external view returns (uint);
    function piano_level     (address _wallet) external view returns (uint);
    function violin_level    (address _wallet) external view returns (uint);
    function horn_level      (address _wallet) external view returns (uint);
    function timpani_level   (address _wallet) external view returns (uint);
    function harp_level      (address _wallet) external view returns (uint);
    
    // Stroll
    function total_strolledDistance (address _wallet) external view returns (uint);
    function total_metSummoners     (address _wallet) external view returns (uint);
    
    // Mail
    function total_mail_sent    (address _wallet) external view returns (uint);
    function total_mail_opened  (address _wallet) external view returns (uint);
    
    // Festival
    function total_voted (address _wallet) external view returns (uint);
    
    // Dice
    function critical_count (address _wallet) external view returns (uint);
    function fumble_count   (address _wallet) external view returns (uint);
    
    // Doing now
    function doing_now (address _wallet) external view returns (string memory);

    // Mimic ERC721 and ERC165 interface for compatibility with Metamask etc.
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function ownerOf(uint256 _tokenId) external view returns (address);
    function tokenURI(uint256 _tokenId) external view returns (string memory);
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}


contract Murasakisan is Ownable, IMurasakisan {

    //address
    address public address_Murasaki_Address;
    function _set_Murasaki_Address(address _address) external onlyOwner {
        address_Murasaki_Address = _address;
    }
    
    //address, get Murasaki_Info address
    function _get_info_address() internal view returns (address) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        return ma.address_Murasaki_Info();
    }

    //summoner
    function summoner(address _wallet) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Main mm = Murasaki_Main(ma.address_Murasaki_Main());
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        uint _summoner = mm.tokenOf(_wallet);
        if (_summoner == 0) {
            return 0;
        }
        bool _isActive = ms.isActive(_summoner);
        if (_isActive) {
            return _summoner;
        } else {
            return 0;
        }
    }
    
    //class
    function class(address _wallet) public view returns (uint) {
        Murasaki_Info mi = Murasaki_Info(_get_info_address());
        return mi.class(summoner(_wallet));
    }
    //age
    function age(address _wallet) public view returns (uint) {
        Murasaki_Info mi = Murasaki_Info(_get_info_address());
        return mi.age(summoner(_wallet));
    }
    //name
    function name(address _wallet) public view returns (string memory) {
        Murasaki_Info mi = Murasaki_Info(_get_info_address());
        return mi.name(summoner(_wallet));
    }
    //level
    function level(address _wallet) public view returns (uint) {
        Murasaki_Info mi = Murasaki_Info(_get_info_address());
        return mi.level(summoner(_wallet));
    }
    //exp
    function exp(address _wallet) public view returns (uint) {
        Murasaki_Info mi = Murasaki_Info(_get_info_address());
        return mi.exp(summoner(_wallet));
    }
    //strength
    function strength(address _wallet) public view returns (uint) {
        Murasaki_Info mi = Murasaki_Info(_get_info_address());
        return mi.strength(summoner(_wallet));
    }
    //dexterity
    function dexterity(address _wallet) public view returns (uint) {
        Murasaki_Info mi = Murasaki_Info(_get_info_address());
        return mi.dexterity(summoner(_wallet));
    }
    //intelligence
    function intelligence(address _wallet) public view returns (uint) {
        Murasaki_Info mi = Murasaki_Info(_get_info_address());
        return mi.intelligence(summoner(_wallet));
    }
    //luck
    function luck(address _wallet) public view returns (uint) {
        Murasaki_Info mi = Murasaki_Info(_get_info_address());
        return mi.luck(summoner(_wallet));
    }
    //coin
    function coin(address _wallet) public view returns (uint) {
        Murasaki_Info mi = Murasaki_Info(_get_info_address());
        return mi.coin(summoner(_wallet));
    }
    //leaf
    function leaf(address _wallet) public view returns (uint) {
        Murasaki_Info mi = Murasaki_Info(_get_info_address());
        return mi.material(summoner(_wallet));
    }
    //total_exp_gained
    function total_exp_gained(address _wallet) public view returns (uint) {
        Murasaki_Info mi = Murasaki_Info(_get_info_address());
        return mi.total_exp_gained(summoner(_wallet));
    }
    //total_coin_mined
    function total_coin_mined(address _wallet) public view returns (uint) {
        Murasaki_Info mi = Murasaki_Info(_get_info_address());
        return mi.total_coin_mined(summoner(_wallet));
    }
    //total_leaf_farmed
    function total_leaf_farmed(address _wallet) public view returns (uint) {
        Murasaki_Info mi = Murasaki_Info(_get_info_address());
        return mi.total_material_farmed(summoner(_wallet));
    }
    //total_item_crafted
    function total_item_crafted(address _wallet) public view returns (uint) {
        Murasaki_Info mi = Murasaki_Info(_get_info_address());
        return mi.total_item_crafted(summoner(_wallet));
    }
    //total_fluffy_received
    function total_fluffy_received(address _wallet) public view returns (uint) {
        Murasaki_Info mi = Murasaki_Info(_get_info_address());
        return mi.total_precious_received(summoner(_wallet));
    }
    //total_feeding_count
    function total_feeding_count(address _wallet) public view returns (uint) {
        Murasaki_Info mi = Murasaki_Info(_get_info_address());
        return mi.total_feeding_count(summoner(_wallet));
    }
    //total_grooming_count
    function total_grooming_count(address _wallet) public view returns (uint) {
        Murasaki_Info mi = Murasaki_Info(_get_info_address());
        return mi.total_grooming_count(summoner(_wallet));
    }
    //total_neglect_count
    function total_neglect_count(address _wallet) public view returns (uint) {
        Murasaki_Info mi = Murasaki_Info(_get_info_address());
        return mi.total_neglect_count(summoner(_wallet));
    }
    //total_critical_count
    function total_critical_count(address _wallet) public view returns (uint) {
        Murasaki_Info mi = Murasaki_Info(_get_info_address());
        return mi.total_critical_count(summoner(_wallet));
    }
    
    //satiety
    function satiety(address _wallet) public view returns (uint) {
        Murasaki_Info mi = Murasaki_Info(_get_info_address());
        return mi.satiety(summoner(_wallet));
    }
    //happy
    function happy(address _wallet) public view returns (uint) {
        Murasaki_Info mi = Murasaki_Info(_get_info_address());
        return mi.happy(summoner(_wallet));
    }
    //precious
    function fluffy(address _wallet) public view returns (uint) {
        Murasaki_Info mi = Murasaki_Info(_get_info_address());
        return mi.precious(summoner(_wallet));
    }
    //not_petrified
    function not_petrified(address _wallet) public view returns (uint) {
        Murasaki_Info mi = Murasaki_Info(_get_info_address());
        return mi.not_petrified(summoner(_wallet));
    }
    //score
    function score(address _wallet) public view returns (uint) {
        Murasaki_Info mi = Murasaki_Info(_get_info_address());
        return mi.score(summoner(_wallet));
    }
    //strength_withItems
    function strength_withItems(address _wallet) public view returns (uint) {
        Murasaki_Info mi = Murasaki_Info(_get_info_address());
        return mi.strength_withItems(summoner(_wallet));
    }
    //dexterity_withItems
    function dexterity_withItems(address _wallet) public view returns (uint) {
        Murasaki_Info mi = Murasaki_Info(_get_info_address());
        return mi.dexterity_withItems(summoner(_wallet));
    }
    //intelligence_withItems
    function intelligence_withItems(address _wallet) public view returns (uint) {
        Murasaki_Info mi = Murasaki_Info(_get_info_address());
        return mi.intelligence_withItems(summoner(_wallet));
    }
    //luck_withItems
    function luck_withItems(address _wallet) public view returns (uint) {
        Murasaki_Info mi = Murasaki_Info(_get_info_address());
        return mi.luck_withItems(summoner(_wallet));
    }
    //luck_withItems_withDice
    function luck_withItems_withDice(address _wallet) public view returns (uint) {
        Murasaki_Info mi = Murasaki_Info(_get_info_address());
        return mi.luck_withItems_withDice(summoner(_wallet));
    }
    //isActive
    function isActive(address _wallet) public view returns (uint) {
        Murasaki_Info mi = Murasaki_Info(_get_info_address());
        return mi.isActive(summoner(_wallet));
    }
    //inHouse
    function inHouse(address _wallet) public view returns (uint) {
        Murasaki_Info mi = Murasaki_Info(_get_info_address());
        return mi.inHouse(summoner(_wallet));
    }
    //birthplace
    function birthplace(address _wallet) public view returns (string memory) {
        Murasaki_Info mi = Murasaki_Info(_get_info_address());
        return mi.allStatus(summoner(_wallet))[0];
    }
    //character
    function character(address _wallet) public view returns (string memory) {
        Murasaki_Info mi = Murasaki_Info(_get_info_address());
        return mi.allStatus(summoner(_wallet))[1];
    }
    //weakpoint
    function weakpoint(address _wallet) public view returns (string memory) {
        Murasaki_Info mi = Murasaki_Info(_get_info_address());
        return mi.allStatus(summoner(_wallet))[3];
    }
    //scent
    function scent(address _wallet) public view returns (string memory) {
        Murasaki_Info mi = Murasaki_Info(_get_info_address());
        return mi.allStatus(summoner(_wallet))[4];
    }
    //personality
    function personality(address _wallet) public view returns (string memory) {
        Murasaki_Info mi = Murasaki_Info(_get_info_address());
        return mi.allStatus(summoner(_wallet))[2];
    }
    //flower
    function flower(address _wallet) public view returns (string memory) {
        Murasaki_Info mi = Murasaki_Info(_get_info_address());
        return mi.allStatus(summoner(_wallet))[5];
    }
    //street
    function street(address _wallet) public view returns (string memory) {
        Murasaki_Info mi = Murasaki_Info(_get_info_address());
        return mi.allStatus(summoner(_wallet))[6];
    }
    //city
    function city(address _wallet) public view returns (string memory) {
        Murasaki_Info mi = Murasaki_Info(_get_info_address());
        return mi.allStatus(summoner(_wallet))[7];
    }
    
    //achievement
    function countOf_achievement (address _wallet) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Main mm = Murasaki_Main(ma.address_Murasaki_Main());
        Murasaki_Function_Achievement mfa = Murasaki_Function_Achievement(ma.address_Murasaki_Function_Achievement());
        uint _summoner = mm.tokenOf(_wallet);
        return mfa.get_countOf_achievement(_summoner);
    }
    function scoreOf_achievement_onChain (address _wallet) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Main mm = Murasaki_Main(ma.address_Murasaki_Main());
        Achievement_onChain ac = Achievement_onChain(ma.address_Achievement_onChain());
        uint _summoner = mm.tokenOf(_wallet);
        return ac.get_score(_summoner);
    }

    //practice
    function clarinet_level (address _wallet) public view returns (uint) {
        Murasaki_Info mi = Murasaki_Info(_get_info_address());
        return mi.get_practiceLevel_clarinet(summoner(_wallet));
    }
    function piano_level (address _wallet) public view returns (uint) {
        Murasaki_Info mi = Murasaki_Info(_get_info_address());
        return mi.get_practiceLevel_piano(summoner(_wallet));
    }
    function violin_level (address _wallet) public view returns (uint) {
        Murasaki_Info mi = Murasaki_Info(_get_info_address());
        return mi.get_practiceLevel_violin(summoner(_wallet));
    }
    function horn_level (address _wallet) public view returns (uint) {
        Murasaki_Info mi = Murasaki_Info(_get_info_address());
        return mi.get_practiceLevel_horn(summoner(_wallet));
    }
    function timpani_level (address _wallet) public view returns (uint) {
        Murasaki_Info mi = Murasaki_Info(_get_info_address());
        return mi.get_practiceLevel_timpani(summoner(_wallet));
    }
    function harp_level (address _wallet) public view returns (uint) {
        Murasaki_Info mi = Murasaki_Info(_get_info_address());
        return mi.get_practiceLevel_harp(summoner(_wallet));
    }
    
    //stroll
    function total_strolledDistance (address _wallet) public view returns (uint) {
        Murasaki_Info mi = Murasaki_Info(_get_info_address());
        return mi.total_strolledDistance(summoner(_wallet));
    }
    function total_metSummoners (address _wallet) public view returns (uint) {
        Murasaki_Info mi = Murasaki_Info(_get_info_address());
        return mi.total_metSummoners(summoner(_wallet));
    }
    
    //mail
    function total_mail_sent (address _wallet) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Main mm = Murasaki_Main(ma.address_Murasaki_Main());
        Murasaki_Mail mml = Murasaki_Mail(ma.address_Murasaki_Mail());
        uint _summoner = mm.tokenOf(_wallet);
        return mml.total_sent(_summoner);
    }
    function total_mail_opened  (address _wallet) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Main mm = Murasaki_Main(ma.address_Murasaki_Main());
        Murasaki_Mail mml = Murasaki_Mail(ma.address_Murasaki_Mail());
        uint _summoner = mm.tokenOf(_wallet);
        return mml.total_opened(_summoner);
    }
    
    //festival
    function total_voted (address _wallet) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Main mm = Murasaki_Main(ma.address_Murasaki_Main());
        Fluffy_Festival ff = Fluffy_Festival(ma.address_Fluffy_Festival());
        uint _summoner = mm.tokenOf(_wallet);
        return ff.voteCount(_summoner);
    }
    
    //dice
    function critical_count (address _wallet) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Main mm = Murasaki_Main(ma.address_Murasaki_Main());
        Murasaki_Dice md = Murasaki_Dice(ma.address_Murasaki_Dice());
        uint _summoner = mm.tokenOf(_wallet);
        return md.critical_count(_summoner);
    }
    function fumble_count (address _wallet) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Main mm = Murasaki_Main(ma.address_Murasaki_Main());
        Murasaki_Dice md = Murasaki_Dice(ma.address_Murasaki_Dice());
        uint _summoner = mm.tokenOf(_wallet);
        return md.fumble_count(_summoner);
    }
    
    //doing now
    function doing_now (address _wallet) public view returns (string memory) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Main mm = Murasaki_Main(ma.address_Murasaki_Main());
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        uint _summoner = mm.tokenOf(_wallet);
        uint _working_status = ms.working_status(_summoner);
            //1:mining, 2:farming, 3:crafting, 4:practice, 5:strolling
        string memory _doing_now;
        if (_working_status == 0) {
            _doing_now = "Resting";
        } else if (_working_status == 1) {
            _doing_now = "Mining";
        } else if (_working_status == 2) {
            _doing_now = "Farming";
        } else if (_working_status == 3) {
            _doing_now = "Crafting";
        } else if (_working_status == 4) {
            _doing_now = "Practicing";
        } else if (_working_status == 5) {
            _doing_now = "Strolling";
        }
        return _doing_now;
    }
    
    //mimic ERC721 and ERC165 interface
    function name() external view returns (string memory) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Main mm = Murasaki_Main(ma.address_Murasaki_Main());
        return mm.name();
    }
    function symbol() external view returns (string memory) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Main mm = Murasaki_Main(ma.address_Murasaki_Main());
        return mm.symbol();
    }
    function ownerOf(uint256 _tokenId) external view returns (address) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Main mm = Murasaki_Main(ma.address_Murasaki_Main());
        return mm.ownerOf(_tokenId);
    }
    function tokenURI(uint256 _tokenId) external view returns (string memory) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_tokenURI mu = Murasaki_tokenURI(ma.address_Murasaki_tokenURI());
        return mu.tokenURI(_tokenId);
    }
    function supportsInterface(bytes4 interfaceId) external pure returns (bool) {
        return
            interfaceId == type(IERC165).interfaceId ||
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId;
    }
    
    //batch getter, uint
    function get_uint_status (address _wallet) external view returns (uint[50] memory) {
        uint[50] memory _res;
        _res[0] = summoner(_wallet);
        _res[1] = class(_wallet);
        _res[2] = age(_wallet);
        _res[3] = level(_wallet);
        _res[4] = strength(_wallet);
        _res[5] = dexterity(_wallet);
        _res[6] = intelligence(_wallet);
        _res[7] = luck(_wallet);
        _res[8] = strength_withItems(_wallet);
        _res[9] = dexterity_withItems(_wallet);
        _res[10] = intelligence_withItems(_wallet);
        _res[11] = luck_withItems(_wallet);
        _res[12] = luck_withItems_withDice(_wallet);
        _res[13] = satiety(_wallet);
        _res[14] = happy(_wallet);
        _res[15] = exp(_wallet);
        _res[16] = coin(_wallet);
        _res[17] = leaf(_wallet);
        _res[18] = fluffy(_wallet);
        _res[19] = score(_wallet);
        _res[20] = total_exp_gained(_wallet);
        _res[21] = total_coin_mined(_wallet);
        _res[22] = total_leaf_farmed(_wallet);
        _res[23] = total_item_crafted(_wallet);
        _res[24] = total_fluffy_received(_wallet);
        _res[25] = total_feeding_count(_wallet);
        _res[26] = total_grooming_count(_wallet);
        _res[27] = total_neglect_count(_wallet);
        _res[28] = total_critical_count(_wallet);
        _res[29] = not_petrified(_wallet);
        _res[30] = isActive(_wallet);
        _res[31] = inHouse(_wallet);
        _res[32] = countOf_achievement(_wallet);
        _res[33] = scoreOf_achievement_onChain(_wallet);
        _res[34] = clarinet_level(_wallet);
        _res[35] = piano_level(_wallet);
        _res[36] = violin_level(_wallet);
        _res[37] = total_strolledDistance(_wallet);
        _res[38] = total_metSummoners(_wallet);
        _res[39] = total_mail_sent(_wallet);
        _res[40] = total_mail_opened(_wallet);
        _res[41] = total_voted(_wallet);
        _res[42] = critical_count(_wallet);
        _res[43] = fumble_count(_wallet);
        return _res;
    }
    
    //batch getter, string
    function get_string_status (address _wallet) external view returns (string[12] memory) {
        string[12] memory _res;
        _res[0] = name(_wallet);
        _res[1] = birthplace(_wallet);
        _res[2] = character(_wallet);
        _res[3] = weakpoint(_wallet);
        _res[4] = scent(_wallet);
        _res[5] = personality(_wallet);
        _res[6] = flower(_wallet);
        _res[7] = street(_wallet);
        _res[8] = city(_wallet);
        _res[9] = doing_now(_wallet);
        return _res;
    }
}


//===SBT/NFT==================================================================================================================


//---Murasaki_Main

contract Murasaki_Main is SoulBoundBadge, Ownable, Pausable {

    //pausable
    function pause() external onlyOwner {
        _pause();
    }
    function unpause() external onlyOwner {
        _unpause();
    }

    //permitted address
    mapping(address => bool) private permitted_address;

    //admin, add or remove permitted_address
    function _add_permitted_address(address _address) external onlyOwner {
        permitted_address[_address] = true;
    }
    function _remove_permitted_address(address _address) external onlyOwner {
        permitted_address[_address] = false;
    }
    
    //admin migratable
    bool isMigratable = false;
    function _set_isMigratable (bool _bool) external onlyOwner {
        isMigratable = _bool;
    }

    //names
    constructor() ERC721("House of Murasaki-san", "HoM") {}

    //summoner info
    mapping(uint => uint) public class;
    mapping(uint => uint) public summoned_time;
    mapping(uint => uint) public seed;

    //summon
    function summon(address _owner, uint _class, uint _seed) external whenNotPaused {
        require(permitted_address[msg.sender] == true);
        //require(notPaused);
        //update summoner info
        uint _now = block.timestamp;
        class[next_token] = _class;
        summoned_time[next_token] = _now;
        seed[next_token] = _seed;
        //mint
        _safeMint(_owner, next_token);
    }
    
    //summon from trial
    function summon_fromTrial(address _owner, uint _class, uint _seed) external whenNotPaused {
        require(permitted_address[msg.sender] == true);
        //require(notPaused);
        //update summoner info
        uint _now = block.timestamp;
        class[next_token] = _class;
        summoned_time[next_token] = _now;
        seed[next_token] = _seed;
        //mint
        _safeMint(_owner, next_token);
    }

    //burn
    function burn(uint _summoner) external whenNotPaused {
        require(permitted_address[msg.sender] == true);
        ERC721._burn(_summoner);
    }

    string[] private flower = [
        "Rose",
        "Marigold",
        "Dandelion",
        "Rosemary",
        "Olive",
        "Holly",
        "Nemophila",
        "Hydrangea",
        "Forget-me-not",
        "Sumire",
        "Gerbera",
        "Anemone"
    ];

    string[] private color = [
        "#E60012",
        "#F39800",
        "#FFF100",
        "#8FC31F",
        "#009944",
        "#009E96",
        "#00A0E9",
        "#0068B7",
        "#1D2088",
        "#920783",
        "#E4007F",
        "#E5004F"
    ];

    //URI
    //Inspired by OraclizeAPI's implementation - MIT license
    //https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
    function toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
    function tokenURI (uint _summoner) public view override returns (string memory) {
        string[9] memory parts;
        parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 128 128"><style>.base { fill: #D81B60; font-family: arial; font-size: 12px; }</style><rect width="128" height="128" fill="';
        parts[1] = color[class[_summoner]];
        parts[2] = '" fill-opacity="0.5"/>';
        parts[3] = '<image width="128" height="128" x="0" y="0" href="data:image/png;base64,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"/><text x="24" y="88" class="base" font-weight="bold">';
        parts[4] = string(abi.encodePacked("#", toString(_summoner)));
        parts[5] = '</text><text x="22" y="102" class="base" font-weight="bold">';
        parts[6] = string(abi.encodePacked("&#x273f;", flower[class[_summoner]]));
        parts[7] = '</text></svg>';
        string memory output = 
            string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7]));
        string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Murasaki-san #', toString(_summoner), '", "description": "House of Murasaki-san. Murasaki-san is a pet living in your wallet on Astar Network. https://murasaki-san.com/", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
        output = string(abi.encodePacked('data:application/json;base64,', json));
        return output;
    }
    
    //admin, for convert
    function set_summoned_time(uint _summoner, uint _value) external {
        require(permitted_address[msg.sender] == true);
        summoned_time[_summoner] = _value;
    }
    
    //migration, only when isMigratable=true & from permitted address
    function migration(uint _summoner, address _owner_new) external {
        require(permitted_address[msg.sender] == true);
        require(isMigratable);
        _burn(_summoner);
        _mint(_owner_new, _summoner);
    }
}


//---Murasaki_Name

contract Murasaki_Name is SoulBoundBadge, Ownable, Pausable {

    //pausable
    function pause() external onlyOwner {
        _pause();
    }
    function unpause() external onlyOwner {
        _unpause();
    }

    //permitted address
    mapping(address => bool) private permitted_address;

    //admin, add or remove permitted_address
    function _add_permitted_address(address _address) external onlyOwner {
        permitted_address[_address] = true;
    }
    function _remove_permitted_address(address _address) external onlyOwner {
        permitted_address[_address] = false;
    }
    
    //admin, overwrite name
    function update_name(uint _name_id, string memory _name_str) external onlyOwner {
        names[_name_id] = _name_str;
    }

    //admin migratable
    bool isMigratable = false;
    function _set_isMigratable (bool _bool) external onlyOwner {
        isMigratable = _bool;
    }

    //names
    constructor() ERC721("Murasaki Name", "MN") {}

    //token info
    mapping(uint => string) public names;
    mapping(uint => uint) public minted_time;
    mapping(uint => uint) public seed;
    
    //name info
    mapping(string => bool) public isMinted;

    //mint
    function mint(address _owner, string memory _name_str, uint _seed) external whenNotPaused {
        require(permitted_address[msg.sender] == true);
        names[next_token] = _name_str;
        uint _now = block.timestamp;
        minted_time[next_token] = _now;
        seed[next_token] = _seed;
        //mint
        isMinted[_name_str] = true;
        _safeMint(_owner, next_token);
    }

    //burn
    function burn(uint _name_id) external whenNotPaused {
        require(permitted_address[msg.sender] == true);
        string memory _name_str = names[_name_id];
        isMinted[_name_str] = false;
        ERC721._burn(_name_id);
    }

    //migration, only when isMigratable=true & from permitted address
    function migration(uint _name_id, address _owner_new) external {
        require(permitted_address[msg.sender] == true);
        require(isMigratable);
        _burn(_name_id);
        _mint(_owner_new, _name_id);
    }
}


//---Murasaki_Craft

contract Murasaki_Craft is ERC2665, Ownable, Pausable {

    //pausable
    function pause() external onlyOwner {
        _pause();
    }
    function unpause() external onlyOwner {
        _unpause();
    }

    //permitted address
    mapping(address => bool) private permitted_address;

    //admin, add or remove permitted_address
    function _add_permitted_address(address _address) external onlyOwner {
        permitted_address[_address] = true;
    }
    function _remove_permitted_address(address _address) external onlyOwner {
        permitted_address[_address] = false;
    }

    //admin. withdraw
    function withdraw(address rec)public onlyOwner{
        payable(rec).transfer(address(this).balance);
    }

    using EnumerableSet for EnumerableSet.UintSet;
    mapping(address => EnumerableSet.UintSet) private mySet;

    //name
    constructor() ERC2665("Murasaki Craft", "MC") {}

    //global variants
    uint public next_item = 1;
    struct item {
        uint item_type;
        uint crafted_time;
        uint crafted_summoner;
        address crafted_wallet;
        string memo;
        uint item_subtype;
    }
    mapping(uint => item) public items;
    mapping(address => uint[320]) public balance_of_type;
    mapping(uint => uint) public seed;
    mapping(uint => uint) public count_of_mint; //item_type => count_of_mint
    
    //mint limit
    uint public mintLimit_perItemType = 900000;
    function _set_mintLimit_perItemType(uint _value) external onlyOwner {
        mintLimit_perItemType = _value;
    }

    //override ERC721 transfer, 
    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override {
        ERC2665._transfer(from, to, tokenId);
        uint _item_type = items[tokenId].item_type;
        balance_of_type[from][_item_type] -= 1;
        balance_of_type[to][_item_type] += 1;
        mySet[from].remove(tokenId);
        mySet[to].add(tokenId);
    }

    //override ERC721 burn
    function _burn(uint256 tokenId) internal virtual override {
        uint _item_type = items[tokenId].item_type;
        address _owner = ERC2665.ownerOf(tokenId);
        balance_of_type[_owner][_item_type] -= 1;
        mySet[_owner].remove(tokenId);
        //ERC721._burn(tokenId);
        ERC2665._transfer(_owner, address(this), tokenId);
    }

    //burn
    function burn(uint256 tokenId) external whenNotPaused {
        require(permitted_address[msg.sender] == true);
        _burn(tokenId);
    }

    //craft
    function craft(
        uint _item_type, 
        uint _summoner, 
        address _wallet, 
        uint _seed, 
        string memory _memo,
        uint _item_subtype
    ) external whenNotPaused {
        require(permitted_address[msg.sender] == true);
        require(count_of_mint[_item_type] < mintLimit_perItemType);
        uint _now = block.timestamp;
        uint _crafting_item = next_item;
        items[_crafting_item] = item(
            _item_type, 
            _now, 
            _summoner, 
            _wallet, 
            _memo, 
            _item_subtype
        );
        balance_of_type[_wallet][_item_type] += 1;  //balanceOf each item type
        count_of_mint[_item_type]++;
        seed[_crafting_item] = _seed;
        mySet[_wallet].add(_crafting_item);
        next_item++;
        _safeMint(_wallet, _crafting_item);
    }
    
    /// @dev Returns list the total number of listed summoners of the given user.
    function myListLength(address user) external view returns (uint) {
        return mySet[user].length();
    }

    /// @dev Returns the ids and the prices of the listed summoners of the given user.
    function myListsAt(
        address user,
        uint start,
        uint count
    ) external view returns (uint[] memory rIds) {
        rIds = new uint[](count);
        for (uint idx = 0; idx < count; idx++) {
            rIds[idx] = mySet[user].at(start + idx);
        }
    }

    /// @dev Returns the ids and the prices of the listed summoners of the given user.
    function myListsAt_withItemType(
        address user,
        uint start,
        uint count
    ) external view returns (uint[] memory rIds) {
        rIds = new uint[](count*2);
        for (uint idx = 0; idx < count; idx++) {
            uint _id = mySet[user].at(start + idx);
            rIds[idx*2] = _id;
            item memory _item = items[_id];
            rIds[idx*2+1] = _item.item_type;
        }
    }
    function myListsAt_withItemTypeAndSubtype(
        address user,
        uint start,
        uint count
    ) external view returns (uint[] memory rIds) {
        rIds = new uint[](count*3);
        for (uint idx = 0; idx < count; idx++) {
            uint _id = mySet[user].at(start + idx);
            rIds[idx*3] = _id;
            item memory _item = items[_id];
            rIds[idx*3+1] = _item.item_type;
            rIds[idx*3+2] = _item.item_subtype;
        }
    }

    //URI
    string public baseURI = "https://murasaki-san.com/src/nftJson/";
    string public tailURI = ".json";
    function set_baseURI(string memory _string) external onlyOwner {
        baseURI = _string;
    }
    function set_tailURI(string memory _string) external onlyOwner {
        tailURI = _string;
    }
    function toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
    //override tokenURI
    function tokenURI (uint _tokenId) public view override returns (string memory) {
        require(_exists(_tokenId), "token must exist");
        uint _item_type = items[_tokenId].item_type;
        return string(
            abi.encodePacked(
                baseURI,
                toString(_item_type),
                tailURI
            )
        );
    }

    //call items as array, need to write in Craft contract
    function get_balance_of_type(address _wallet) public view returns (uint[320] memory) {
        return balance_of_type[_wallet];
    }
    function balanceOfType(address _wallet, uint _item_type) external view returns (uint) {
        return balance_of_type[_wallet][_item_type];
    }

    // Transfer fees
    
    //noFee address
    mapping(address => bool) private noFee_address;
    
    //set transfer fee
    uint public TRANSFER_FEE = 100 * 10**18;   //wei
    
    //a wallet collecting fees
    address private bufferTreasury_address;
    
    //admin
    function _add_noFee_address(address _address) external onlyOwner {
        noFee_address[_address] = true;
    }
    function _remove_noFee_address(address _address) external onlyOwner {
        noFee_address[_address] = false;
    }
    function _set_transfer_fee(uint _value) external onlyOwner {
        TRANSFER_FEE = _value;
    }
    function _set_bufferTreasury_address(address _address) external onlyOwner {
        bufferTreasury_address = _address;
    }
    
    //override ERC2665
    //function getTransferFee(uint256 _tokenId) external view override returns (uint256) {
    function getTransferFee(uint256) external view override returns (uint256) {
        return TRANSFER_FEE;
    }
    //function getTransferFee(uint256 _tokenId, string calldata _currencySymbol) external view override returns (uint256) {
    function getTransferFee(uint256, string calldata) external view override returns (uint256) {
        return TRANSFER_FEE;
    }
    
    //override transfer functions
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override payable whenNotPaused {
        //added code, when not noFee address, require transfer fee
        if (noFee_address[from] == false && noFee_address[to] == false) {
            require(msg.value >= TRANSFER_FEE);
            payable(bufferTreasury_address).transfer(address(this).balance);
        }
        require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
        _transfer(from, to, tokenId);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override payable whenNotPaused {
        if (noFee_address[from] == false && noFee_address[to] == false) {
            require(msg.value >= TRANSFER_FEE);
            payable(bufferTreasury_address).transfer(address(this).balance);
        }
        safeTransferFrom(from, to, tokenId, "");
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public virtual override payable whenNotPaused {
        if (noFee_address[from] == false && noFee_address[to] == false) {
            require(msg.value >= TRANSFER_FEE);
            payable(bufferTreasury_address).transfer(address(this).balance);
        }
        require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
        _safeTransfer(from, to, tokenId, _data);
    }
    
    //admin, using convertion, convert item info from old contract
    function _admin_craft_convert(
        uint _item_type, 
        uint _summoner, 
        address _wallet_crafted, 
        //uint _seed, 
        //string memory _memo,
        uint _item_id,
        uint _crafted_time,
        address _wallet_to
    ) external {
        require(permitted_address[msg.sender] == true);
        //uint32 _now = uint32(block.timestamp);
        //uint32 _crafting_item = next_item;
        //items[_crafting_item] = item(_item_type, _now, _summoner, _wallet, _memo);
        string memory _memo = "converted";
        items[_item_id] = item(_item_type, _crafted_time, _summoner, _wallet_crafted, _memo, 0);
        balance_of_type[_wallet_to][_item_type] += 1;  //balanceOf each item type
        count_of_mint[_item_type]++;
        //seed[_item_id] = _seed;
        seed[_item_id] = 8888;
        mySet[_wallet_to].add(_item_id);
        //next_item++;
        _safeMint(_wallet_to, _item_id);
    }
    
    //admin, using convertion, set next_item
    function _admin_set_next_item (uint _next_item) external {
        require(permitted_address[msg.sender] == true);
        next_item = _next_item;
    }
}


//===TBA==================================================================================================================


//---Murasaki_TBAAccount
contract Murasaki_TBAAccount is IERC165, IERC1271, IERC6551Account {
    uint256 private _nonce;

    receive() external payable {}

    function executeCall(
        address to,
        uint256 value,
        bytes calldata data
    ) external payable returns (bytes memory result) {
        require(msg.sender == owner(), "Not token owner");

        bool success;
        (success, result) = to.call{value: value}(data);

        if (!success) {
            assembly {
                revert(add(result, 32), mload(result))
            }
        }

        _nonce++;
    }

    function token()
        public
        view
        returns (uint256 chainId, address tokenContract, uint256 tokenId)
    {
        uint256 length = address(this).code.length;
        return
            abi.decode(
                Bytecode.codeAt(address(this), length - 0x60, length),
                (uint256, address, uint256)
            );
    }

    function owner() public view returns (address) {
        (uint256 chainId, address tokenContract, uint256 tokenId) = this
            .token();
        if (chainId != block.chainid) return address(0);

        return IERC721(tokenContract).ownerOf(tokenId);
    }

    function nonce() external view returns (uint256) {
        return _nonce;
    }

    function supportsInterface(bytes4 interfaceId) public pure returns (bool) {
        return (interfaceId == type(IERC165).interfaceId ||
            interfaceId == type(IERC6551Account).interfaceId);
    }

    function isValidSignature(
        bytes32 hash,
        bytes memory signature
    ) external view returns (bytes4 magicValue) {
        bool isValid = SignatureChecker.isValidSignatureNow(
            owner(),
            hash,
            signature
        );

        if (isValid) {
            return IERC1271.isValidSignature.selector;
        }

        return "";
    }
}


//---Murasaki_TBARegistry
contract Murasaki_TBARegistry is IERC6551Registry {
    error InitializationFailed();

    function createAccount(
        address implementation,
        uint256 chainId,
        address tokenContract,
        uint256 tokenId,
        uint256 salt,
        bytes calldata initData
    ) external returns (address) {
        bytes memory code = _creationCode(
            implementation,
            chainId,
            tokenContract,
            tokenId,
            salt
        );

        address _account = Create2.computeAddress(
            bytes32(salt),
            keccak256(code)
        );

        if (_account.code.length != 0) return _account;

        _account = Create2.deploy(0, bytes32(salt), code);

        if (initData.length != 0) {
            (bool success, ) = _account.call(initData);
            if (!success) revert InitializationFailed();
        }

        emit AccountCreated(
            _account,
            implementation,
            chainId,
            tokenContract,
            tokenId,
            salt
        );

        return _account;
    }

    function account(
        address implementation,
        uint256 chainId,
        address tokenContract,
        uint256 tokenId,
        uint256 salt
    ) external view returns (address) {
        bytes32 bytecodeHash = keccak256(
            _creationCode(implementation, chainId, tokenContract, tokenId, salt)
        );

        return Create2.computeAddress(bytes32(salt), bytecodeHash);
    }

    function _creationCode(
        address implementation_,
        uint256 chainId_,
        address tokenContract_,
        uint256 tokenId_,
        uint256 salt_
    ) internal pure returns (bytes memory) {
        return
            abi.encodePacked(
                hex"3d60ad80600a3d3981f3363d3d373d3d3d363d73",
                implementation_,
                hex"5af43d82803e903d91602b57fd5bf3",
                abi.encode(salt_, chainId_, tokenContract_, tokenId_)
            );
    }
}


//===Storage==================================================================================================================


//---Murasaki_Address

contract Murasaki_Address is Ownable {

    address public address_Murasaki_Main;
    address public address_Murasaki_Name;
    address public address_Murasaki_Craft;
    address public address_Murasaki_Parameter;
    address public address_Murasaki_Storage;
    address public address_Murasaki_Storage_Score;
    address public address_Murasaki_Storage_Nui;
    address public address_Murasaki_Function_Share;
    address public address_Murasaki_Function_Summon_and_LevelUp;
    address public address_Murasaki_Function_Feeding_and_Grooming;
    address public address_Murasaki_Function_Mining_and_Farming;
    address public address_Murasaki_Function_Crafting;
    address public address_Murasaki_Function_Crafting2;
    address public address_Murasaki_Function_Crafting_Codex;
    address public address_Murasaki_Function_Name;
    address public address_Murasaki_Function_Achievement;
    address public address_Murasaki_Function_Staking_Reward;
    address public address_Murasaki_Dice;
    address public address_Murasaki_Mail;
    address public address_Fluffy_Festival;
    address public address_Murasaki_Info;
    //address public address_Murasaki_Info_fromWallet;
    address public address_Murasaki_Lootlike;
    address public address_Murasaki_tokenURI;
    address public address_BufferVault;
    address public address_BuybackTreasury;
    address public address_AstarBase;
    address public address_Staking_Wallet;
    address public address_Coder_Wallet;
    address public address_Illustrator_Wallet;
    address public address_Achievement_onChain;
    address public address_Murasaki_Function_Music_Practice;
    address public address_Murasaki_Address_Regular;
    address public address_Murasaki_Address_Trial;
    address public address_Stroll;
    address public address_Murasaki_Market_Item;
    address public address_Murasakisan;
    address public address_Trial_Converter;
    address public address_Murasaki_Storage_Extra;
    address public address_Pippel_NFT;
    address public address_Pippel_Function;
    address public address_Pippel_Codex;
    address public address_Murasaki_TBARegistry;
    address public address_Murasaki_TBAAccount;
    
    function set_Murasaki_Main(address _address) external onlyOwner {
        address_Murasaki_Main = _address;
    }
    function set_Murasaki_Name(address _address) external onlyOwner {
        address_Murasaki_Name = _address;
    }
    function set_Murasaki_Craft(address _address) external onlyOwner {
        address_Murasaki_Craft = _address;
    }
    function set_Murasaki_Parameter(address _address) external onlyOwner {
        address_Murasaki_Parameter = _address;
    }
    function set_Murasaki_Storage(address _address) external onlyOwner {
        address_Murasaki_Storage = _address;
    }
    function set_Murasaki_Storage_Score(address _address) external onlyOwner {
        address_Murasaki_Storage_Score = _address;
    }
    function set_Murasaki_Storage_Nui(address _address) external onlyOwner {
        address_Murasaki_Storage_Nui = _address;
    }
    function set_Murasaki_Function_Share(address _address) external onlyOwner {
        address_Murasaki_Function_Share = _address;
    }
    function set_Murasaki_Function_Summon_and_LevelUp(address _address) external onlyOwner {
        address_Murasaki_Function_Summon_and_LevelUp = _address;
    }
    function set_Murasaki_Function_Feeding_and_Grooming(address _address) external onlyOwner {
        address_Murasaki_Function_Feeding_and_Grooming = _address;
    }
    function set_Murasaki_Function_Mining_and_Farming(address _address) external onlyOwner {
        address_Murasaki_Function_Mining_and_Farming = _address;
    }
    function set_Murasaki_Function_Crafting(address _address) external onlyOwner {
        address_Murasaki_Function_Crafting = _address;
    }
    function set_Murasaki_Function_Crafting2(address _address) external onlyOwner {
        address_Murasaki_Function_Crafting2 = _address;
    }
    function set_Murasaki_Function_Crafting_Codex(address _address) external onlyOwner {
        address_Murasaki_Function_Crafting_Codex = _address;
    }
    function set_Murasaki_Function_Name(address _address) external onlyOwner {
        address_Murasaki_Function_Name = _address;
    }
    function set_Murasaki_Function_Achievement(address _address) external onlyOwner {
        address_Murasaki_Function_Achievement = _address;
    }
    function set_Murasaki_Function_Staking_Reward(address _address) external onlyOwner {
        address_Murasaki_Function_Staking_Reward = _address;
    }
    function set_Murasaki_Dice(address _address) external onlyOwner {
        address_Murasaki_Dice = _address;
    }
    function set_Murasaki_Mail(address _address) external onlyOwner {
        address_Murasaki_Mail = _address;
    }
    function set_Fluffy_Festival(address _address) external onlyOwner {
        address_Fluffy_Festival = _address;
    }
    function set_Murasaki_Info(address _address) external onlyOwner {
        address_Murasaki_Info = _address;
    }
    /*
    function set_Murasaki_Info_fromWallet(address _address) external onlyOwner {
        address_Murasaki_Info_fromWallet = _address;
    }
    */
    function set_Murasaki_Lootlike(address _address) external onlyOwner {
        address_Murasaki_Lootlike = _address;
    }
    function set_Murasaki_tokenURI(address _address) external onlyOwner {
        address_Murasaki_tokenURI = _address;
    }
    function set_BufferVault(address _address) external onlyOwner {
        address_BufferVault = _address;
    }
    function set_BuybackTreasury(address _address) external onlyOwner {
        address_BuybackTreasury = _address;
    }
    function set_AstarBase(address _address) external onlyOwner {
        address_AstarBase = _address;
    }
    function set_Staking(address _address) external onlyOwner {
        address_Staking_Wallet = _address;
    }
    function set_Coder(address _address) external onlyOwner {
        address_Coder_Wallet = _address;
    }
    function set_Illustrator(address _address) external onlyOwner {
        address_Illustrator_Wallet = _address;
    }
    function set_Achievement_onChain(address _address) external onlyOwner {
        address_Achievement_onChain = _address;
    }
    function set_Murasaki_Function_Music_Practice(address _address) external onlyOwner {
        address_Murasaki_Function_Music_Practice = _address;
    }
    function set_Murasaki_Address_Regular(address _address) external onlyOwner {
        address_Murasaki_Address_Regular = _address;
    }
    function set_Murasaki_Address_Trial(address _address) external onlyOwner {
        address_Murasaki_Address_Trial = _address;
    }
    function set_Stroll(address _address) external onlyOwner {
        address_Stroll = _address;
    }
    function set_Murasaki_Market_Item(address _address) external onlyOwner {
        address_Murasaki_Market_Item = _address;
    }
    function set_Murasakisan(address _address) external onlyOwner {
        address_Murasakisan = _address;
    }
    function set_Trial_Converter(address _address) external onlyOwner {
        address_Trial_Converter = _address;
    }
    function set_Murasaki_Storage_Extra(address _address) external onlyOwner {
        address_Murasaki_Storage_Extra = _address;
    }
    function set_Pippel_NFT(address _address) external onlyOwner {
        address_Pippel_NFT = _address;
    }
    function set_Pippel_Function(address _address) external onlyOwner {
        address_Pippel_Function = _address;
    }
    function set_Pippel_Codex(address _address) external onlyOwner {
        address_Pippel_Codex = _address;
    }
    function set_Murasaki_TBARegistry(address _address) external onlyOwner {
        address_Murasaki_TBARegistry = _address;
    }
    function set_Murasaki_TBAAccount(address _address) external onlyOwner {
        address_Murasaki_TBAAccount = _address;
    }
    
    //all getter
    function get_addresses() external view returns (address[50] memory) {
        address[50] memory _res;
        _res[1] = address_Murasaki_Main;
        _res[2] = address_Murasaki_Name;
        _res[3] = address_Murasaki_Craft;
        _res[4] = address_Murasaki_Parameter;
        _res[5] = address_Murasaki_Storage;
        _res[6] = address_Murasaki_Storage_Score;
        _res[7] = address_Murasaki_Storage_Nui;
        _res[8] = address_Murasaki_Function_Share;
        _res[9] = address_Murasaki_Function_Summon_and_LevelUp;
        _res[10] = address_Murasaki_Function_Feeding_and_Grooming;
        _res[11] = address_Murasaki_Function_Mining_and_Farming;
        _res[12] = address_Murasaki_Function_Crafting;
        _res[13] = address_Murasaki_Function_Crafting2;
        _res[14] = address_Murasaki_Function_Crafting_Codex;
        _res[15] = address_Murasaki_Function_Name;
        _res[16] = address_Murasaki_Function_Achievement;
        _res[17] = address_Murasaki_Function_Staking_Reward;
        _res[18] = address_Murasaki_Dice;
        _res[19] = address_Murasaki_Mail;
        _res[20] = address_Fluffy_Festival;
        _res[21] = address_Murasaki_Info;
        //_res[22] = address_Murasaki_Info_fromWallet;
        _res[23] = address_Murasaki_Lootlike;
        _res[24] = address_Murasaki_tokenURI;
        _res[25] = address_BufferVault;
        _res[26] = address_BuybackTreasury;
        _res[27] = address_AstarBase;
        _res[28] = address_Staking_Wallet;
        _res[29] = address_Coder_Wallet;
        _res[30] = address_Illustrator_Wallet;
        _res[31] = address_Achievement_onChain;
        _res[32] = address_Murasaki_Function_Music_Practice;
        _res[33] = address_Murasaki_Address_Regular;
        _res[34] = address_Murasaki_Address_Trial;
        _res[35] = address_Stroll;
        _res[36] = address_Murasaki_Market_Item;
        _res[37] = address_Murasakisan;
        _res[38] = address_Trial_Converter;
        _res[39] = address_Murasaki_Storage_Extra;
        _res[40] = address_Pippel_NFT;
        _res[41] = address_Pippel_Function;
        _res[42] = address_Pippel_Codex;
        _res[43] = address_Murasaki_TBARegistry;
        _res[44] = address_Murasaki_TBAAccount;
        return _res;
    }
    
    //all setter
    function set_addresses(address[50] memory _addresses) external onlyOwner {
        address_Murasaki_Main = _addresses[1];
        address_Murasaki_Name = _addresses[2];
        address_Murasaki_Craft = _addresses[3];
        address_Murasaki_Parameter = _addresses[4];
        address_Murasaki_Storage = _addresses[5];
        address_Murasaki_Storage_Score = _addresses[6];
        address_Murasaki_Storage_Nui = _addresses[7];
        address_Murasaki_Function_Share = _addresses[8];
        address_Murasaki_Function_Summon_and_LevelUp = _addresses[9];
        address_Murasaki_Function_Feeding_and_Grooming = _addresses[10];
        address_Murasaki_Function_Mining_and_Farming = _addresses[11];
        address_Murasaki_Function_Crafting = _addresses[12];
        address_Murasaki_Function_Crafting2 = _addresses[13];
        address_Murasaki_Function_Crafting_Codex = _addresses[14];
        address_Murasaki_Function_Name = _addresses[15];
        address_Murasaki_Function_Achievement = _addresses[16];
        address_Murasaki_Function_Staking_Reward = _addresses[17];
        address_Murasaki_Dice = _addresses[18];
        address_Murasaki_Mail = _addresses[19];
        address_Fluffy_Festival = _addresses[20];
        address_Murasaki_Info = _addresses[21];
        //_res[22] = _addresses[22];
        address_Murasaki_Lootlike = _addresses[23];
        address_Murasaki_tokenURI = _addresses[24];
        address_BufferVault = _addresses[25];
        address_BuybackTreasury = _addresses[26];
        address_AstarBase = _addresses[27];
        address_Staking_Wallet = _addresses[28];
        address_Coder_Wallet = _addresses[29];
        address_Illustrator_Wallet = _addresses[30];
        address_Achievement_onChain = _addresses[31];
        address_Murasaki_Function_Music_Practice = _addresses[32];
        address_Murasaki_Address_Regular = _addresses[33];
        address_Murasaki_Address_Trial = _addresses[34];
        address_Stroll = _addresses[35];
        address_Murasaki_Market_Item = _addresses[36];
        address_Murasakisan = _addresses[37];
        address_Trial_Converter = _addresses[38];
        address_Murasaki_Storage_Extra = _addresses[39];
        address_Pippel_NFT = _addresses[40];
        address_Pippel_Function = _addresses[41];
        address_Pippel_Codex = _addresses[42];
        address_Murasaki_TBARegistry = _addresses[43];
        address_Murasaki_TBAAccount = _addresses[44];
    }
}


//---Murasaki_Parameter

contract Murasaki_Parameter is Ownable {

    //permitted address
    mapping(address => bool) private permitted_address;

    //admin, add or remove permitted_address
    function _add_permitted_address(address _address) external onlyOwner {
        permitted_address[_address] = true;
    }
    function _remove_permitted_address(address _address) external onlyOwner {
        permitted_address[_address] = false;
    }

    //global variants
    bool public isPaused = true;
    uint public BASE_SEC = 86400;
    uint public SPEED = 100; //100=100%
    uint public PRICE = 500 * 10**18;   //wei
    uint public DAY_PETRIFIED = 30;
    uint public STAKING_REWARD_SEC = 2592000; //30 days
    uint public ELECTED_FLUFFY_TYPE = 0;
    string public DEVELOPER_SUMMONER_NAME = "*Fluffy Kingdom*";
    uint public EXP_FROM_PRESENTBOX = 50;
    uint public LIMIT_MINT = 9999999999;
    bool public isTrial = false;

    //modifier
    modifier onlyPermitted {
        require(permitted_address[msg.sender]);
        _;
    }

    //admin, set global variants
    function _set_isPaused(bool _bool) external onlyPermitted {
        isPaused = _bool;
    }
    function _set_base_sec(uint _base_sec) external onlyPermitted {
        BASE_SEC = _base_sec;
    }
    function _set_speed(uint _speed) external onlyPermitted {
        SPEED = _speed;
    }
    function _set_price(uint _price) external onlyPermitted {
        PRICE = _price;
    }
    function _set_day_petrified(uint _day_petrified) external onlyPermitted {
        DAY_PETRIFIED = _day_petrified;
    }
    function _set_elected_fluffy_type(uint _value) external onlyPermitted {
        ELECTED_FLUFFY_TYPE = _value;
    }
    function _set_developer_summoner_name(string memory _string) external onlyPermitted {
        DEVELOPER_SUMMONER_NAME = _string;
    }
    function _set_exp_from_presentbox(uint _value) external onlyPermitted {
        EXP_FROM_PRESENTBOX = _value;
    }
    function _set_limit_mint(uint _value) external onlyPermitted {
        LIMIT_MINT = _value;
    }
    function _set_isTrial(bool _bool) external onlyPermitted {
        isTrial = _bool;
    }
}


//---Murasaki_Storage

contract Murasaki_Storage is Ownable {

    //permitted address
    mapping(address => bool) private permitted_address;

    //admin, add or remove permitted_address
    function _add_permitted_address(address _address) external onlyOwner {
        permitted_address[_address] = true;
    }
    function _remove_permitted_address(address _address) external onlyOwner {
        permitted_address[_address] = false;
    }

    //status
    mapping(uint => uint) public level;
    mapping(uint => uint) public exp;
    mapping(uint => uint) public strength;
    mapping(uint => uint) public dexterity;
    mapping(uint => uint) public intelligence;
    mapping(uint => uint) public luck;
    mapping(uint => uint) public next_exp_required;
    mapping(uint => uint) public last_level_up_time;

    //resouse
    mapping(uint => uint) public coin;
    mapping(uint => uint) public material;

    //treating
    mapping(uint => uint) public last_feeding_time;
    mapping(uint => uint) public last_grooming_time;

    //working
    mapping(uint => uint) public working_status;
        //1:mining, 2:farming, 3:crafting, 4:practice, 5:strolling
    mapping(uint => uint) public mining_start_time;
    mapping(uint => uint) public farming_start_time;
    mapping(uint => uint) public crafting_start_time;
    mapping(uint => uint) public crafting_item_type;
    mapping(uint => uint) public total_mining_sec;
    mapping(uint => uint) public total_farming_sec;
    mapping(uint => uint) public total_crafting_sec;
    mapping(uint => uint) public last_total_mining_sec;
    mapping(uint => uint) public last_total_farming_sec;
    mapping(uint => uint) public last_total_crafting_sec;
    mapping(uint => uint) public last_grooming_time_plus_working_time;

    //active or disable, initial default value = false, using burn
    mapping(uint => bool) public isActive;
    
    //inHouse
    mapping(uint => bool) public inHouse;
    
    //staking reward counter
    mapping(uint => uint) public staking_reward_counter;
    mapping(uint => uint) public total_staking_reward_counter;
    mapping(uint => uint) public last_counter_update_time;
    
    //crafting resume
    mapping(uint => uint) public crafting_resume_flag;
    mapping(uint => uint) public crafting_resume_item_type;
    mapping(uint => uint) public crafting_resume_item_dc;
    
    //practice
    mapping(uint => uint) public exp_clarinet;
    mapping(uint => uint) public exp_piano;
    mapping(uint => uint) public exp_violin;
    mapping(uint => uint) public exp_horn;
    mapping(uint => uint) public exp_timpani;
    mapping(uint => uint) public exp_harp;
    mapping(uint => uint) public practice_item_id;
    mapping(uint => uint) public practice_start_time;

    //modifier
    modifier onlyPermitted {
        require(permitted_address[msg.sender]);
        _;
    }

    //set status
    function set_level(uint _summoner, uint _value) external onlyPermitted {
        level[_summoner] = _value;
    }
    function set_exp(uint _summoner, uint _value) external onlyPermitted {
        exp[_summoner] = _value;
    }
    function set_strength(uint _summoner, uint _value) external onlyPermitted {
        strength[_summoner] = _value;
    }
    function set_dexterity(uint _summoner, uint _value) external onlyPermitted {
        dexterity[_summoner] = _value;
    }
    function set_intelligence(uint _summoner, uint _value) external onlyPermitted {
        intelligence[_summoner] = _value;
    }
    function set_luck(uint _summoner, uint _value) external onlyPermitted {
        luck[_summoner] = _value;
    }
    function set_next_exp_required(uint _summoner, uint _value) external onlyPermitted {
        next_exp_required[_summoner] = _value;
    }
    function set_last_level_up_time(uint _summoner, uint _value) external onlyPermitted {
        last_level_up_time[_summoner] = _value;
    }
    function set_coin(uint _summoner, uint _value) external onlyPermitted {
        coin[_summoner] = _value;
    }
    function set_material(uint _summoner, uint _value) external onlyPermitted {
        material[_summoner] = _value;
    }
    function set_last_feeding_time(uint _summoner, uint _value) external onlyPermitted {
        last_feeding_time[_summoner] = _value;
    }
    function set_last_grooming_time(uint _summoner, uint _value) external onlyPermitted {
        last_grooming_time[_summoner] = _value;
    }
    function set_mining_start_time(uint _summoner, uint _value) external onlyPermitted {
        mining_start_time[_summoner] = _value;
    }
    function set_farming_start_time(uint _summoner, uint _value) external onlyPermitted {
        farming_start_time[_summoner] = _value;
    }
    function set_crafting_start_time(uint _summoner, uint _value) external onlyPermitted {
        crafting_start_time[_summoner] = _value;
    }
    function set_crafting_item_type(uint _summoner, uint _value) external onlyPermitted {
        crafting_item_type[_summoner] = _value;
    }
    function set_total_mining_sec(uint _summoner, uint _value) external onlyPermitted {
        total_mining_sec[_summoner] = _value;
    }
    function set_total_farming_sec(uint _summoner, uint _value) external onlyPermitted {
        total_farming_sec[_summoner] = _value;
    }
    function set_total_crafting_sec(uint _summoner, uint _value) external onlyPermitted {
        total_crafting_sec[_summoner] = _value;
    }
    function set_last_total_mining_sec(uint _summoner, uint _value) external onlyPermitted {
        last_total_mining_sec[_summoner] = _value;
    }
    function set_last_total_farming_sec(uint _summoner, uint _value) external onlyPermitted {
        last_total_farming_sec[_summoner] = _value;
    }
    function set_last_total_crafting_sec(uint _summoner, uint _value) external onlyPermitted {
        last_total_crafting_sec[_summoner] = _value;
    }
    function set_last_grooming_time_plus_working_time(uint _summoner, uint _value) external onlyPermitted {
        last_grooming_time_plus_working_time[_summoner] = _value;
    }
    function set_isActive(uint _summoner, bool _bool) external onlyPermitted {
        isActive[_summoner] = _bool;
    }
    function set_inHouse(uint _summoner, bool _bool) external onlyPermitted {
        inHouse[_summoner] = _bool;
    }
    function set_staking_reward_counter(uint _summoner, uint _value) external onlyPermitted {
        staking_reward_counter[_summoner] = _value;
    }
    function set_total_staking_reward_counter(uint _summoner, uint _value) external onlyPermitted {
        total_staking_reward_counter[_summoner] = _value;
    }
    function set_last_counter_update_time(uint _summoner, uint _value) external onlyPermitted {
        last_counter_update_time[_summoner] = _value;
    }
    function set_crafting_resume_flag(uint _summoner, uint _value) external onlyPermitted {
        crafting_resume_flag[_summoner] = _value;
    }
    function set_crafting_resume_item_type(uint _summoner, uint _value) external onlyPermitted {
        crafting_resume_item_type[_summoner] = _value;
    }
    function set_crafting_resume_item_dc(uint _summoner, uint _value) external onlyPermitted {
        crafting_resume_item_dc[_summoner] = _value;
    }
    function set_exp_clarinet(uint _summoner, uint _value) external onlyPermitted {
        exp_clarinet[_summoner] = _value;
    }
    function set_exp_piano(uint _summoner, uint _value) external onlyPermitted {
        exp_piano[_summoner] = _value;
    }
    function set_exp_violin(uint _summoner, uint _value) external onlyPermitted {
        exp_violin[_summoner] = _value;
    }
    function set_exp_horn(uint _summoner, uint _value) external onlyPermitted {
        exp_horn[_summoner] = _value;
    }
    function set_exp_timpani(uint _summoner, uint _value) external onlyPermitted {
        exp_timpani[_summoner] = _value;
    }
    function set_exp_harp(uint _summoner, uint _value) external onlyPermitted {
        exp_harp[_summoner] = _value;
    }
    function set_practice_item_id(uint _summoner, uint _value) external onlyPermitted {
        practice_item_id[_summoner] = _value;
    }
    function set_practice_start_time(uint _summoner, uint _value) external onlyPermitted {
        practice_start_time[_summoner] = _value;
    }
    function set_working_status(uint _summoner, uint _value) external onlyPermitted {
        working_status[_summoner] = _value;
    }
}


//---Murasaki_Storage_Score

contract Murasaki_Storage_Score is Ownable {

    //permitted address
    mapping(address => bool) private permitted_address;

    //admin, add or remove permitted_address
    function _add_permitted_address(address _address) external onlyOwner {
        permitted_address[_address] = true;
    }
    function _remove_permitted_address(address _address) external onlyOwner {
        permitted_address[_address] = false;
    }

    //status
    mapping(uint => uint) public total_exp_gained;
    mapping(uint => uint) public total_coin_mined;
    mapping(uint => uint) public total_material_farmed;
    mapping(uint => uint) public total_item_crafted;
    mapping(uint => uint) public total_precious_received;
    
    //230609 add
    mapping(uint => uint) public total_feeding_count;
    mapping(uint => uint) public total_grooming_count;
    mapping(uint => uint) public total_neglect_count;
    mapping(uint => uint) public total_critical_count;
    
    //global
    uint public global_total_feeding_count;
    uint public global_total_grooming_count;
    uint public global_total_coin_mined;
    uint public global_total_material_farmed;
    uint public global_total_item_crafted;
    uint public global_total_precious_received;
    uint public global_total_practiceTime_clarinet;
    uint public global_total_practiceTime_piano;
    uint public global_total_practiceTime_violin;

    //modifier
    modifier onlyPermitted {
        require(permitted_address[msg.sender]);
        _;
    }

    //set status
    function set_total_exp_gained(uint _summoner, uint _value) external onlyPermitted {
        total_exp_gained[_summoner] = _value;
    }
    function set_total_coin_mined(uint _summoner, uint _value) external onlyPermitted {
        total_coin_mined[_summoner] = _value;
    }
    function set_total_material_farmed(uint _summoner, uint _value) external onlyPermitted {
        total_material_farmed[_summoner] = _value;
    }
    function set_total_item_crafted(uint _summoner, uint _value) external onlyPermitted {
        total_item_crafted[_summoner] = _value;
    }
    function set_total_precious_received(uint _summoner, uint _value) external onlyPermitted {
        total_precious_received[_summoner] = _value;
    }
    
    //230609 add
    function set_total_feeding_count(uint _summoner, uint _value) external onlyPermitted {
        total_feeding_count[_summoner] = _value;
    }
    function set_total_grooming_count(uint _summoner, uint _value) external onlyPermitted {
        total_grooming_count[_summoner] = _value;
    }
    function set_total_neglect_count(uint _summoner, uint _value) external onlyPermitted {
        total_neglect_count[_summoner] = _value;
    }
    function set_total_critical_count(uint _summoner, uint _value) external onlyPermitted {
        total_critical_count[_summoner] = _value;
    }
    
    //global, set
    function set_global_total_feeding_count (uint _value) external onlyPermitted {
        global_total_feeding_count = _value;
    }
    function set_global_total_grooming_count (uint _value) external onlyPermitted {
        global_total_grooming_count = _value;
    }
    function set_global_total_coin_mined (uint _value) external onlyPermitted {
        global_total_coin_mined = _value;
    }
    function set_global_total_material_farmed (uint _value) external onlyPermitted {
        global_total_material_farmed = _value;
    }
    function set_global_total_item_crafted (uint _value) external onlyPermitted {
        global_total_item_crafted = _value;
    }
    function set_global_total_precious_received (uint _value) external onlyPermitted {
        global_total_precious_received = _value;
    }
    function set_global_total_practiceTime_clarinet (uint _value) external onlyPermitted {
        global_total_practiceTime_clarinet = _value;
    }
    function set_global_total_practiceTime_piano (uint _value) external onlyPermitted {
        global_total_practiceTime_piano = _value;
    }
    function set_global_total_practiceTime_violin (uint _value) external onlyPermitted {
        global_total_practiceTime_violin = _value;
    }
    
    //global, increment
    function increment_global_total_feeding_count (uint _value) external onlyPermitted {
        global_total_feeding_count += _value;
    }
    function increment_global_total_grooming_count (uint _value) external onlyPermitted {
        global_total_grooming_count += _value;
    }
    function increment_global_total_coin_mined (uint _value) external onlyPermitted {
        global_total_coin_mined += _value;
    }
    function increment_global_total_material_farmed (uint _value) external onlyPermitted {
        global_total_material_farmed += _value;
    }
    function increment_global_total_item_crafted (uint _value) external onlyPermitted {
        global_total_item_crafted += _value;
    }
    function increment_global_total_precious_received (uint _value) external onlyPermitted {
        global_total_precious_received += _value;
    }
    function increment_global_total_practiceTime_clarinet (uint _value) external onlyPermitted {
        global_total_practiceTime_clarinet += _value;
    }
    function increment_global_total_practiceTime_piano (uint _value) external onlyPermitted {
        global_total_practiceTime_piano += _value;
    }
    function increment_global_total_practiceTime_violin (uint _value) external onlyPermitted {
        global_total_practiceTime_violin += _value;
    }
}


//---Murasaki_Storage_Nui

contract Murasaki_Storage_Nui is Ownable {

    //permitted address
    mapping(address => bool) private permitted_address;

    //admin, add or remove permitted_address
    function _add_permitted_address(address _address) external onlyOwner {
        permitted_address[_address] = true;
    }
    function _remove_permitted_address(address _address) external onlyOwner {
        permitted_address[_address] = false;
    }
    
    //status of nui
    mapping(uint => uint) public mint_time;
    mapping(uint => uint) public summoner;
    mapping(uint => uint) public class;
    mapping(uint => uint) public level;
    mapping(uint => uint) public strength;
    mapping(uint => uint) public dexterity;
    mapping(uint => uint) public intelligence;
    mapping(uint => uint) public luck;
    mapping(uint => uint) public total_exp_gained;
    mapping(uint => uint) public total_coin_mined;
    mapping(uint => uint) public total_material_farmed;
    mapping(uint => uint) public total_item_crafted;
    mapping(uint => uint) public total_precious_received;
    mapping(uint => uint) public score;

    //modifier
    modifier onlyPermitted {
        require(permitted_address[msg.sender]);
        _;
    }

    //set status
    function set_mint_time(uint _item_nui, uint _value) external onlyPermitted {
        mint_time[_item_nui] = _value;
    }
    function set_summoner(uint _item_nui, uint _value) external onlyPermitted {
        summoner[_item_nui] = _value;
    }
    function set_class(uint _item_nui, uint _value) external onlyPermitted {
        class[_item_nui] = _value;
    }
    function set_level(uint _item_nui, uint _value) external onlyPermitted {
        level[_item_nui] = _value;
    }
    function set_strength(uint _item_nui, uint _value) external onlyPermitted {
        strength[_item_nui] = _value;
    }
    function set_dexterity(uint _item_nui, uint _value) external onlyPermitted {
        dexterity[_item_nui] = _value;
    }
    function set_intelligence(uint _item_nui, uint _value) external onlyPermitted {
        intelligence[_item_nui] = _value;
    }
    function set_luck(uint _item_nui, uint _value) external onlyPermitted {
        luck[_item_nui] = _value;
    }
    function set_total_exp_gained(uint _item_nui, uint _value) external onlyPermitted {
        total_exp_gained[_item_nui] = _value;
    }
    function set_total_coin_mined(uint _item_nui, uint _value) external onlyPermitted {
        total_coin_mined[_item_nui] = _value;
    }
    function set_total_material_farmed(uint _item_nui, uint _value) external onlyPermitted {
        total_material_farmed[_item_nui] = _value;
    }
    function set_total_item_crafted(uint _item_nui, uint _value) external onlyPermitted {
        total_item_crafted[_item_nui] = _value;
    }
    function set_total_precious_received(uint _item_nui, uint _value) external onlyPermitted {
        total_precious_received[_item_nui] = _value;
    }
    function set_score(uint _item_nui, uint _value) external onlyPermitted {
        score[_item_nui] = _value;
    }
}


//---Murasaki_Storage_Extra

contract Murasaki_Storage_Extra is Ownable {

    //permitted address
    mapping(address => bool) private permitted_address;

    //admin, add or remove permitted_address
    function _add_permitted_address(address _address) external onlyOwner {
        permitted_address[_address] = true;
    }
    function _remove_permitted_address(address _address) external onlyOwner {
        permitted_address[_address] = false;
    }
    
    //modifier
    modifier onlyPermitted {
        require(permitted_address[msg.sender]);
        _;
    }

    //storages
    mapping(uint => mapping(uint => uint)) public storage_uint;
    mapping(uint => mapping(uint => mapping(uint => uint))) public storage_mapping;
    
    //setter
    function set_storage (
        uint _storageId, 
        uint _summoner, 
        uint _value
    ) external onlyPermitted {
        storage_uint[_storageId][_summoner] = _value;
    }
    function set_storage_mapping (
        uint _storageId, 
        uint _summoner, 
        uint _index, 
        uint _value
    ) external onlyPermitted {
        storage_mapping[_storageId][_summoner][_index] = _value;
    }

    //adder
    function add_storage (
        uint _storageId, 
        uint _summoner, 
        uint _value
    ) external onlyPermitted {
        storage_uint[_storageId][_summoner] += _value;
    }
    function add_storage_mapping (
        uint _storageId, 
        uint _summoner, 
        uint _index, 
        uint _value
    ) external onlyPermitted {
        storage_mapping[_storageId][_summoner][_index] += _value;
    }
    
    //getter
    function get_storage (
        uint _storageId, 
        uint _summoner
    ) external view returns (uint) {
        return storage_uint[_storageId][_summoner];
    }
    function get_storage_mapping (
        uint _storageId, 
        uint _summoner,
        uint _index
    ) external view returns (uint) {
        return storage_mapping[_storageId][_summoner][_index];
    }
}


//===Function==================================================================================================================


//---Share*

contract Murasaki_Function_Share is Ownable, ReentrancyGuard, Pausable {

    //pausable
    function pause() external onlyOwner {
        _pause();
    }
    function unpause() external onlyOwner {
        _unpause();
    }

    //address
    address public address_Murasaki_Address;
    function _set_Murasaki_Address(address _address) external onlyOwner {
        address_Murasaki_Address = _address;
    }

    //salt
    uint private _salt = 0;
    function update_salt(uint _summoner) external onlyOwner {
        _salt = dn(_summoner, 10);
    }
    
    //check trial
    function isTrial() external view returns (bool) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        return mp.isTrial();
    }

    //check owner of summoner
    function check_owner(uint _summoner, address _wallet) external view whenNotPaused returns (bool) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Main mm = Murasaki_Main(ma.address_Murasaki_Main());
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        // possess and isActive
        return (mm.ownerOf(_summoner) == _wallet && ms.isActive(_summoner));
    }

    //get owner of summoner
    function get_owner(uint _summoner) public view returns (address) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Main mm = Murasaki_Main(ma.address_Murasaki_Main());
        return mm.ownerOf(_summoner);
    }
    
    //get summoner from wallet
    function get_summoner(address _address) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Main mm = Murasaki_Main(ma.address_Murasaki_Main());
        return mm.tokenOf(_address);
    }

    //craft

    //check owner of item
    function check_owner_ofItem(uint _item, address _wallet) external view returns (bool) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Craft mc = Murasaki_Craft(ma.address_Murasaki_Craft());
        return (mc.ownerOf(_item) == _wallet);
    }

    //get balance of type
    function get_balance_of_type_specific(address _wallet, uint _item_type) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Craft mc = Murasaki_Craft(ma.address_Murasaki_Craft());
        return mc.balance_of_type(_wallet, _item_type);
    }

    //call items as array
    function get_balance_of_type_array(address _wallet) external view returns (uint[320] memory) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Craft mc = Murasaki_Craft(ma.address_Murasaki_Craft());
        return mc.get_balance_of_type(_wallet);
    }

    //call items as array from summoner
    function get_balance_of_type_array_from_summoner(uint _summoner) public view returns (uint[320] memory) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Main mm = Murasaki_Main(ma.address_Murasaki_Main());
        Murasaki_Craft mc = Murasaki_Craft(ma.address_Murasaki_Craft());
        address _owner = mm.ownerOf(_summoner);
        return mc.get_balance_of_type(_owner);
    }

    //calc satiety
    function calc_satiety(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        uint SPEED = mp.SPEED();
        uint BASE_SEC = mp.BASE_SEC();
        uint _now = block.timestamp;
        uint _delta_sec = _now - ms.last_feeding_time(_summoner);
        uint _base = BASE_SEC *100/SPEED;   // 240122 /2 -> x1
        uint _satiety;
        if (_delta_sec >= _base) {
            _satiety = 0;
        } else {
            _satiety = 100 * (_base - _delta_sec) / _base;
        }
        //prevent short interval botting
        if (_satiety > 0 && _satiety < 100) {
            _satiety += 1;
        }
        return _satiety;
    }

    //calc happy
    function calc_happy (uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        uint SPEED = mp.SPEED();
        uint BASE_SEC = mp.BASE_SEC();
        uint _now = block.timestamp;
        uint _delta_sec = _now - ms.last_grooming_time(_summoner);
        uint _base = BASE_SEC *3 *100/SPEED;
        uint _happy;
        if (_delta_sec >= _base) {
            _happy = 0;
        } else {
            _happy = 100 * (_base - _delta_sec) / _base;
        }
        //prevent short interval botting
        if (_happy > 0 && _happy < 100) {
            _happy += 1;
        }
        return _happy;
    }

    //calc fluffy
    // 0.31
    function calc_precious (uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        Pippel_Function pf = Pippel_Function(ma.address_Pippel_Function());
        Murasaki_Craft mc = Murasaki_Craft(ma.address_Murasaki_Craft());
        Achievement_onChain ac = Achievement_onChain(ma.address_Achievement_onChain());
        address _owner = get_owner(_summoner);
        uint _precious_score = 0;
        //fluffy
        uint _elected_precious_type = mp.ELECTED_FLUFFY_TYPE();
        uint _balance_of_type;
        uint _additionalScore = 0;
        for (uint i = 201; i <= 212; i++) {
            //doll, fluffy * 60
            _balance_of_type = mc.balance_of_type(_owner, i+36);
            if (_balance_of_type > 0) {
                _additionalScore += _balance_of_type * 2*60 +30 +2;
            }
            //fluffiest, fluffy * 20
            _balance_of_type = mc.balance_of_type(_owner, i+24);
            if (_balance_of_type > 0) {
                _additionalScore += _balance_of_type * 2*20 +8 +2;
            }
            //fluffier, fluffy * 5
            _balance_of_type = mc.balance_of_type(_owner, i+12);
            if (_balance_of_type > 0) {
                _additionalScore += _balance_of_type * 2*5 +2;
            }
            //fluffy
            _balance_of_type = mc.balance_of_type(_owner, i);
            if (_balance_of_type > 0) {
                _additionalScore += _balance_of_type * 2;
            }
            //fluffly festival modification, x2 score
            if (i == _elected_precious_type) {
                _additionalScore *= 2;
            }
            _precious_score += _additionalScore;
        }
        
        // 230920
        // pippe score addition 0.06 $ASTR
        // 1 pippel NFT = 10 pippel score = 1 fluffy score = 0.01 LUK
        if (mp.isTrial() == false) {
            _precious_score += pf.calc_pippelScore(_summoner) / 10;
        }
        
        //level cap for fluffy, 800/Lv20 = 40/Lv
        uint _lv = ms.level(_summoner);
        if (_precious_score > _lv*40) {
            _precious_score = _lv*40;
        }

        // 240123
        // add achievement on chain score, 0.11
        _precious_score += ac.get_score_itemChecked(_summoner);

        return _precious_score;
    }

    //calc fluffy
    // 0.31
    function calc_precious_withoutAc (uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        Pippel_Function pf = Pippel_Function(ma.address_Pippel_Function());
        Murasaki_Craft mc = Murasaki_Craft(ma.address_Murasaki_Craft());
        address _owner = get_owner(_summoner);
        uint _precious_score = 0;
        //fluffy
        uint _elected_precious_type = mp.ELECTED_FLUFFY_TYPE();
        uint _balance_of_type;
        uint _additionalScore = 0;
        for (uint i = 201; i <= 212; i++) {
            //doll, fluffy * 60
            _balance_of_type = mc.balance_of_type(_owner, i+36);
            if (_balance_of_type > 0) {
                _additionalScore += _balance_of_type * 2*60 +30 +2;
            }
            //fluffiest, fluffy * 20
            _balance_of_type = mc.balance_of_type(_owner, i+24);
            if (_balance_of_type > 0) {
                _additionalScore += _balance_of_type * 2*20 +8 +2;
            }
            //fluffier, fluffy * 5
            _balance_of_type = mc.balance_of_type(_owner, i+12);
            if (_balance_of_type > 0) {
                _additionalScore += _balance_of_type * 2*5 +2;
            }
            //fluffy
            _balance_of_type = mc.balance_of_type(_owner, i);
            if (_balance_of_type > 0) {
                _additionalScore += _balance_of_type * 2;
            }
            //fluffly festival modification, x2 score
            if (i == _elected_precious_type) {
                _additionalScore *= 2;
            }
            _precious_score += _additionalScore;
        }
        
        // 230920
        // pippe score addition 0.06 $ASTR
        // 1 pippel NFT = 10 pippel score = 1 fluffy score = 0.01 LUK
        if (mp.isTrial() == false) {
            _precious_score += pf.calc_pippelScore(_summoner) / 10;
        }
        
        //level cap for fluffy, 800/Lv20 = 40/Lv
        uint _lv = ms.level(_summoner);
        if (_precious_score > _lv*40) {
            _precious_score = _lv*40;
        }

        // 240123
        // add achievement on chain score, 0.11
        //_precious_score += ac.get_score_itemChecked(_summoner);

        return _precious_score;
    }

    //call_name_from_summoner
    function call_name_from_summoner(uint _summoner) external view returns (string memory) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        Murasaki_Name mn = Murasaki_Name(ma.address_Murasaki_Name());
        Murasaki_Main mm = Murasaki_Main(ma.address_Murasaki_Main());    
        if (_summoner == 0) {
            return mp.DEVELOPER_SUMMONER_NAME();
        }
        address _owner = mm.ownerOf(_summoner);
        uint _name_id = mn.tokenOf(_owner);
        string memory _name_str = mn.names(_name_id);
        return _name_str;
    }

    //calc_score
    function calc_score(uint _summoner) public view returns (uint) {
        if (_summoner == 0) {
            return 0;
        }
        uint _score = 0;
        _score += _calc_score_total(_summoner);
        _score += _calc_score_nft(_summoner);
        return _score;
    }
    function _calc_score_total(uint _summoner) internal view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage_Score mss = Murasaki_Storage_Score(ma.address_Murasaki_Storage_Score());
        uint _total_exp_gained = mss.total_exp_gained(_summoner);
        uint _total_coin_mined = mss.total_coin_mined(_summoner);
        uint _total_material_farmed = mss.total_material_farmed(_summoner);
        uint _total_item_crafted = mss.total_item_crafted(_summoner);
        uint _total_precious_received = mss.total_precious_received(_summoner);
        uint _score = 0;
        _score += _total_exp_gained;
        _score += _total_coin_mined;
        _score += _total_material_farmed;
        _score += _total_item_crafted * 3000 + _total_item_crafted ** 2 * 300;
        _score += _total_precious_received * 500 + _total_precious_received ** 2 * 50;
        return _score;
    }
    function _calc_score_nft(uint _summoner) internal view returns (uint) {
        uint[320] memory _array = get_balance_of_type_array_from_summoner(_summoner);
        uint _score = 0;
        for (uint i=1; i<=255; i++) {
            if (_array[i] > 0) {
                //common item, 1/5 of item_crafted
                if (i <= 64) {
                    _score += _array[i] * 600;
                //uncommon item, x4 of common
                } else if (i <= 128) {
                    _score += _array[i] * 2400;
                //rare item, x4 of uncommon
                } else if (i <= 196) {
                    _score += _array[i] * 9600;
                //bank, pouch, mail, ignored
                } else if (i <= 200) {
                    _score += 0;
                //fluffy, 1/5 of precious_received
                } else if (i <= 212) {
                    _score += _array[i] * 100;
                //fluffier, x4 of fluffy
                } else if (i <= 224) {
                    _score += _array[i] * 400;
                //fluffiest, x4 of fluffier
                } else if (i <= 236) {
                    _score += _array[i] * 1600;
                //nui, x4 of fluffiest
                } else if (i <= 248) {
                    _score += _array[i] * 6400;
                }
            }
        }
        return _score;
    }
        
    //calc_exp_addition_rate_from_nui, item_nui required
    //return XXX% * 100; 30000 = +300%
    function calc_exp_addition_rate_from_nui(uint _summoner, uint _item_nui) external view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage_Nui msn = Murasaki_Storage_Nui(ma.address_Murasaki_Storage_Nui());
        //call summoner score
        uint _score_summoner = calc_score(_summoner);
        //call nui score
        uint _score_nui = msn.score(_item_nui);
        //formula: _score_nui / _score_summoner * 100 - 100 (%) 
        uint _percentx100;
        if (_score_nui * 100 <= _score_summoner * 103) {
            _percentx100 = 0;
        } else {
            _percentx100 = ( (_score_nui * 100 / _score_summoner) - 100 ) * 100;
        }
        if (_percentx100 < 300) {
            _percentx100 = 300;
        } else if (_percentx100 > 30000) {
            _percentx100 = 30000;
        }
        return _percentx100;
    }

    //calc_exp_addition_rate_from_twinkle
    //return XXX% * 100; 150 = +0.15%
    //0.06
    function calc_exp_addition_rate_from_twinkle(uint _summoner) external view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Craft mc = Murasaki_Craft(ma.address_Murasaki_Craft());
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        address _owner = mfs.get_owner(_summoner);
        uint _twinkle_1 = mc.balanceOfType(_owner, 251);
        uint _twinkle_2 = mc.balanceOfType(_owner, 252);
        //uint _twinkle_3 = mc.balanceOfType(_owner, 253);
        //uint _twinkle_4 = mc.balanceOfType(_owner, 254);
        //uint _twinkle_5 = mc.balanceOfType(_owner, 255);
        uint _percentx100 = 0;
        _percentx100 += _twinkle_1*10;  //0.1%
        _percentx100 += _twinkle_2*20;  //0.2%
        //_percentx100 += _twinkle_3*30;  //0.3%
        //_percentx100 += _twinkle_4*40;  //0.4%
        //_percentx100 += _twinkle_5*50;  //0.5%
        if (_percentx100 > ms.level(_summoner) * 50) {
            _percentx100 = ms.level(_summoner) * 50;    // limit: 0.5%/Lv
        }
        return _percentx100;
    }

    //cehck petrification, debends on only feeding
    function not_petrified(uint _summoner) public view returns (bool) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        uint SPEED = mp.SPEED();
        uint BASE_SEC = mp.BASE_SEC();
        uint DAY_PETRIFIED = mp.DAY_PETRIFIED();
        uint _now = block.timestamp;
        uint _delta_sec = _now - ms.last_feeding_time(_summoner);
        if ( _delta_sec >= BASE_SEC * DAY_PETRIFIED *100/SPEED) {
            return false;
        }else {
            return true;
        }
    }
    
    //calc dapps staking amount of mm contract
    //local: AstarBase: 0x64582688EF82Bcce7F6260eE1384656e1D33b4bB
    //Shibuya, AstarBase: 0xF183f51D3E8dfb2513c15B046F848D4a68bd3F5D
    //Astar, AstarBase: 0x8E2fa5A4D4e4f0581B69aF2f8F2Ef2CF205aE8F0
    //Astar, communy reward: 0x101B453a02f961b4E3f0526eCd4c533c3A80d795
    //SAND, 0xA8D66d36C1955Ec7bA6237FE83Bb75f293575288
    function calc_dapps_staking_amount(address _wallet) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        IAstarBase ASTARBASE = IAstarBase(ma.address_AstarBase());
        uint _staker_raw = ASTARBASE.checkStakerStatusOnContract(_wallet, ma.address_Murasaki_Main());
        uint _staker = _staker_raw / (10 ** 18);
        return _staker;
    }
    
    //get speed_of_dappsStaking
    function get_speed_of_dappsStaking(uint _summoner) external view returns (uint) {
        address _owner = get_owner(_summoner);
        uint _staker = calc_dapps_staking_amount(_owner);
        uint _speed;
        // 241114, updated
        if (_staker < 500) {
            _speed = 0;
        } else if (_staker < 1000) {
            _speed = 102;
        } else if (_staker < 2000) {
            _speed = 103;
        } else if (_staker < 3000) {
            _speed = 107;
        } else if (_staker < 4000) {
            _speed = 113;
        } else if (_staker < 5000) {
            _speed = 126;
        } else if (_staker < 6000) {
            _speed = 146;
        } else if (_staker < 7000) {
            _speed = 172;
        } else if (_staker < 8000) {
            _speed = 205;
        } else if (_staker < 9000) {
            _speed = 244;
        } else if (_staker < 10000) {
            _speed = 297;
        } else if (_staker < 20000) {
            _speed = 362;
        } else if (_staker < 30000) {
            _speed = 379;
        } else if (_staker < 40000) {
            _speed = 395;
        } else if (_staker < 50000) {
            _speed = 408;
        } else if (_staker < 75000) {
            _speed = 418;
        } else if (_staker < 100000) {
            _speed = 425;
        } else if (_staker >= 100000) {
            _speed = 428;
        }
        return _speed;
    }
    
    //luck challenge
    
    // score buffer 
    // To reduce gas fees, luck values are buffered during a interval.
    mapping (uint => uint) private _updated_lucks;   // summoner => luck
    mapping (uint => uint) private _last_updated_luck_time;  // summoner => time
    uint _LUCK_UPDATE_DURATION = 72000; // 20 hr
    function _update_luck_update_duration (uint _val) external onlyOwner {
        _LUCK_UPDATE_DURATION = _val;
    }
    
    // score buffer, achievement on-chain
    // ac scores are buffered for 5d
    mapping (uint => uint) private _updated_ac;   // summoner => luck
    mapping (uint => uint) private _last_updated_ac_time;  // summoner => time
    uint _AC_UPDATE_DURATION = 432000; // 5 d
    function _update_ac_update_duration (uint _val) external onlyOwner {
        _AC_UPDATE_DURATION = _val;
    }
    
    // could execute anytime
    function luck_challenge(uint _summoner) public nonReentrant whenNotPaused returns (bool) {
        // prepare luck
        uint _luck;
        // check updated time
        // when more than 8 hr have passed since the last updated time, update the luck.
        if (block.timestamp - _last_updated_luck_time[_summoner] >= _LUCK_UPDATE_DURATION) {
            Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
            Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
            Murasaki_Dice md = Murasaki_Dice(ma.address_Murasaki_Dice());
            // calc luck
            _luck = ms.luck(_summoner);
            _luck += calc_precious_withoutAc(_summoner);
            _luck += md.get_rolled_dice(_summoner); //0.06
            
            // check updated time for ac
            // compared to normal method:
            //   when update: +0.05-0.06
            //   when not update: -0.08-0.09
            uint _ac;
            if (block.timestamp - _last_updated_ac_time[_summoner] >= _AC_UPDATE_DURATION) {
                Achievement_onChain ac = Achievement_onChain(ma.address_Achievement_onChain());
                _ac = ac.get_score_itemChecked(_summoner);
                _updated_ac[_summoner] = _ac;
                _last_updated_ac_time[_summoner] = block.timestamp;
            } else {
                _ac = _updated_ac[_summoner];
            }
            _luck += _ac;
            
            // update luck
            _updated_lucks[_summoner] = _luck;
            // update time
            _last_updated_luck_time[_summoner] = block.timestamp;
        } else {
            _luck = _updated_lucks[_summoner];
        }
        // critical challenge, 0.02
        if (dn(_summoner, 10000) <= _luck) {
            return true;
        } else {
            return false;
        }
    }

    //random
    //for block chain
    function d10000(uint _summoner) external view returns (uint) {
        return dn(_summoner, 10000);
    }
    function d1000(uint _summoner) external view returns (uint) {
        return dn(_summoner, 1000);
    }
    function d100(uint _summoner) external view returns (uint) {
        return dn(_summoner, 100);
    }
    function seed(uint _summoner) external view returns (uint) {
        return _seed(_summoner);
    }
    function d20(uint _summoner) external view returns (uint) {
        return dn(_summoner, 20);
    }    
    function d12(uint _summoner) external view returns (uint) {
        return dn(_summoner, 12);
    }    
    function d10(uint _summoner) external view returns (uint) {
        return dn(_summoner, 10);
    }
    function d8(uint _summoner) external view returns (uint) {
        return dn(_summoner, 8);
    }
    function d6(uint _summoner) external view returns (uint) {
        return dn(_summoner, 6);
    }
    function d4(uint _summoner) external view returns (uint) {
        return dn(_summoner, 4);
    }
    function dn(uint _summoner, uint _number) public view returns (uint) {
        return _seed(_summoner) % _number;
    }
    function _random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }
    function _seed(uint _summoner) internal view returns (uint rand) {
        rand = _random(
            string(
                abi.encodePacked(
                    block.timestamp,
                    blockhash(block.number - 1 - _salt),
                    block.coinbase,
                    _summoner,
                    msg.sender
                )
            )
        );
    }
    
    // batch item call
    function batch_itemCall (uint[] memory _items, uint _count) external view returns (
        uint[] memory _item_types,
        uint[] memory _crafted_summoners,
        uint[] memory _item_subtypes
    ) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Craft mc = Murasaki_Craft(ma.address_Murasaki_Craft());
        _item_types = new uint[](_count);
        _crafted_summoners = new uint[](_count);
        _item_subtypes = new uint[](_count);
        for (uint i = 0; i < _count; i++) {
            (
                uint _item_type,
                ,
                uint _crafted_summoner,
                ,
                ,
                uint _item_subtype
            ) = mc.items(_items[i]);
            _item_types[i] = _item_type;
            _crafted_summoners[i] = _crafted_summoner;
            _item_subtypes[i] = _item_subtype;
        }
    }
    
    // call name from wallet address
    function call_name_from_wallet (address _wallet) external view returns (string memory) {
        // ignore 0x
        if (_wallet == 0x0000000000000000000000000000000000000000) {
            return "";
        }
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Name mn = Murasaki_Name(ma.address_Murasaki_Name());
        uint _name_id = mn.tokenOf(_wallet);
        string memory _name_str = mn.names(_name_id);
        return _name_str;
    }
}


//---Summon_and_LevelUp*

contract Murasaki_Function_Summon_and_LevelUp is Ownable, ReentrancyGuard, Pausable {

    //pausable
    function pause() external onlyOwner {
        _pause();
    }
    function unpause() external onlyOwner {
        _unpause();
    }

    //address
    address public address_Murasaki_Address;
    function _set_Murasaki_Address(address _address) external onlyOwner {
        address_Murasaki_Address = _address;
    }

    //admin. withdraw
    function withdraw(address rec)public onlyOwner{
        payable(rec).transfer(address(this).balance);
    }

    //summon
    event Summon(uint indexed _summoner, address _wallet, uint _class);
    function summon(uint _class) external payable nonReentrant whenNotPaused {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Main mm = Murasaki_Main(ma.address_Murasaki_Main());
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        //check wallet
        require(_check_wallet(msg.sender));
        require(mp.isPaused() == false);
        require( mm.next_token() < mp.LIMIT_MINT() );
        uint PRICE = mp.PRICE();
        uint BASE_SEC = mp.BASE_SEC();
        uint SPEED = mp.SPEED();
        require(msg.value >= PRICE);
        require(0 <= _class && _class <= 11);
        //summon on mm, mint NTT
        uint _summoner = mm.next_token();
        uint _seed = mfs.seed(_summoner);
        mm.summon(msg.sender, _class, _seed);
        //summon on ms, initialize sutatus
        uint _now = block.timestamp;
        ms.set_level(_summoner, 1);
        ms.set_exp(_summoner, 0);
        ms.set_strength(_summoner, 300);
        ms.set_dexterity(_summoner, 300);
        ms.set_intelligence(_summoner, 300);
        ms.set_luck(_summoner, 300);
        //ms.set_next_exp_required(_summoner, 1000);
        ms.set_next_exp_required(_summoner, 560);
        ms.set_last_level_up_time(_summoner, _now);
        ms.set_coin(_summoner, 0);
        ms.set_material(_summoner, 0);
        ms.set_last_feeding_time(_summoner, _now - BASE_SEC * 100 / SPEED / 4);
        ms.set_last_grooming_time(_summoner, _now - BASE_SEC * 100 / SPEED / 4);
        ms.set_mining_start_time(_summoner, 0);
        ms.set_farming_start_time(_summoner, 0);
        ms.set_crafting_start_time(_summoner, 0);
        ms.set_crafting_item_type(_summoner, 0);
        ms.set_total_mining_sec(_summoner, 0);
        ms.set_total_farming_sec(_summoner, 0);
        ms.set_total_crafting_sec(_summoner, 0);
        ms.set_last_total_mining_sec(_summoner, 0);
        ms.set_last_total_farming_sec(_summoner, 0);
        ms.set_last_total_crafting_sec(_summoner, 0);
        ms.set_last_grooming_time_plus_working_time(_summoner, _now - BASE_SEC * 100 / SPEED / 4);
        ms.set_isActive(_summoner, true);
        ms.set_inHouse(_summoner, true);
        ms.set_staking_reward_counter(_summoner, mp.STAKING_REWARD_SEC());
        //fee transfer, 45% for buyback, 45% for staking, rest for team
        payable(ma.address_Coder_Wallet()).transfer(PRICE/20);          //5%
        payable(ma.address_Illustrator_Wallet()).transfer(PRICE/20);    //5%
        payable(ma.address_Staking_Wallet()).transfer(address(this).balance/2);  //45%
        payable(ma.address_BuybackTreasury()).transfer(address(this).balance);   //45%
        //event
        emit Summon(_summoner, msg.sender, _class);
    }
    function _check_wallet (address _wallet) internal view returns (bool) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        bool _res;
        if (mp.isTrial()) { //when trial, not possess regular summoner
            Murasaki_Address ma_reg = Murasaki_Address(ma.address_Murasaki_Address_Regular());
            Murasaki_Main mm_reg = Murasaki_Main(ma_reg.address_Murasaki_Main());
            if (mm_reg.tokenOf(_wallet) == 0) {
                _res = true;
            }
        } else {    //when regular, not possess trial summoner
            Murasaki_Address ma_trial = Murasaki_Address(ma.address_Murasaki_Address_Trial());
            Murasaki_Main mm_trial = Murasaki_Main(ma_trial.address_Murasaki_Main());
            if (mm_trial.tokenOf(_wallet) == 0) {
                _res = true;
            }
        }
        return _res;
    }

    //burn
    event Burn(uint indexed _summoner);
    function burn(uint _summoner) external nonReentrant whenNotPaused {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Main mm = Murasaki_Main(ma.address_Murasaki_Main());
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        //check owner
        require(mfs.check_owner(_summoner, msg.sender));
        //burn on mm
        mm.burn(_summoner);
        //burn on ms, inactivate
        ms.set_isActive(_summoner, false);
        //event
        emit Burn(_summoner);
    }

    //petrified check
    function not_petrified(uint _summoner) internal view returns (bool) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        return mfs.not_petrified(_summoner);
    }

    //level-up
    event Level_up(uint indexed _summoner, uint _level, uint str_add, uint dex_add, uint int_add, uint luk_add);
    function level_up (uint _summoner) external nonReentrant whenNotPaused {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        require(mfs.check_owner(_summoner, msg.sender));
        //require(ms.mining_status(_summoner) == 0 && ms.farming_status(_summoner) == 0 && ms.crafting_status(_summoner) == 0);
        require(ms.working_status(_summoner) == 0);
        require(ms.exp(_summoner) >= ms.next_exp_required(_summoner));
        //trial check
        require(_check_trial(_summoner));
        //petrified check
        require(not_petrified(_summoner));
        //calculate working percent
        //uint _now = block.timestamp;
        uint _base_sec = block.timestamp - ms.last_level_up_time(_summoner);
        uint _resting_sec = _base_sec
             - ms.last_total_mining_sec(_summoner)
             - ms.last_total_farming_sec(_summoner)
             - ms.last_total_crafting_sec(_summoner);
        uint _percent_mining = 200 * (ms.last_total_mining_sec(_summoner) + _resting_sec/4) / _base_sec;
        uint _percent_farming = 200 * (ms.last_total_farming_sec(_summoner) + _resting_sec/4) / _base_sec;
        uint _percent_crafting = 200 * (ms.last_total_crafting_sec(_summoner) + _resting_sec/4) / _base_sec;
        uint _percent_resting = 200 * (_resting_sec/4) / _base_sec;
        //status addition
        ms.set_strength(_summoner, ms.strength(_summoner) + _percent_mining);
        ms.set_dexterity(_summoner, ms.dexterity(_summoner) + _percent_farming);
        ms.set_intelligence(_summoner, ms.intelligence(_summoner) + _percent_crafting);
        ms.set_luck(_summoner, ms.luck(_summoner) + _percent_resting);
        //update timestamp
        ms.set_last_total_mining_sec(_summoner, 0);
        ms.set_last_total_farming_sec(_summoner, 0);
        ms.set_last_total_crafting_sec(_summoner, 0);
        //reset feeding, grooming, and exp
        ms.set_last_feeding_time(_summoner, block.timestamp);
        ms.set_last_grooming_time(_summoner, block.timestamp);
        ms.set_exp(_summoner, 0);
        //level-up
        uint _next_level = ms.level(_summoner) + 1;
        ms.set_level(_summoner, _next_level);
        ms.set_last_level_up_time(_summoner, block.timestamp);
        //update next_exp_required
        if (_next_level == 2) {
            ms.set_next_exp_required(_summoner, 1000);
        }else if (_next_level == 3) {
            ms.set_next_exp_required(_summoner, 3000);
        }else if (_next_level == 4) {
            ms.set_next_exp_required(_summoner, 6000);
        }else if (_next_level == 5) {
            ms.set_next_exp_required(_summoner, 10000);
        }else if (_next_level == 6) {
            ms.set_next_exp_required(_summoner, 15000);
        }else if (_next_level == 7) {
            ms.set_next_exp_required(_summoner, 21000);
        }else if (_next_level == 8) {
            ms.set_next_exp_required(_summoner, 28000);
        }else if (_next_level == 9) {
            ms.set_next_exp_required(_summoner, 36000);
        }else if (_next_level == 10) {
            ms.set_next_exp_required(_summoner, 45000);
        }else if (_next_level == 11) {
            ms.set_next_exp_required(_summoner, 55000);
        }else if (_next_level == 12) {
            ms.set_next_exp_required(_summoner, 66000);
        }else if (_next_level == 13) {
            ms.set_next_exp_required(_summoner, 78000);
        }else if (_next_level == 14) {
            ms.set_next_exp_required(_summoner, 91000);
        }else if (_next_level == 15) {
            ms.set_next_exp_required(_summoner, 105000);
        }else if (_next_level == 16) {
            ms.set_next_exp_required(_summoner, 120000);
        }else if (_next_level == 17) {
            ms.set_next_exp_required(_summoner, 136000);
        }else if (_next_level == 18) {
            ms.set_next_exp_required(_summoner, 153000);
        }else if (_next_level == 19) {
            ms.set_next_exp_required(_summoner, 171000);
        }else if (_next_level == 20) {
            ms.set_next_exp_required(_summoner, 190000);
        }else if (_next_level == 21) {
            ms.set_next_exp_required(_summoner, 9999999);
        }
        //first level-up bonus
        if (_next_level == 2) {
            _mint_presentbox(uint(0), msg.sender);
        }
        //event
        emit Level_up(
            _summoner, 
            _next_level, 
            _percent_mining, 
            _percent_farming, 
            _percent_crafting, 
            _percent_resting
        );
    }
    
    function _check_trial(uint _summoner) internal view returns (bool) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        bool _res;
        if ( mp.isTrial() == false || ms.level(_summoner) < 4) {
            _res = true;
        }
        return _res;
    }

    //internal, mint presentbox
    function _mint_presentbox(uint _summoner_from, address _wallet_to) internal {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Craft mc = Murasaki_Craft(ma.address_Murasaki_Craft());
        uint _seed = mfs.seed(_summoner_from);
        uint _item_type = 200;
        string memory _memo = "first level-up bonus";
        mc.craft(_item_type, _summoner_from, _wallet_to, _seed, _memo, 0);
    }
    
    //migration, price=summon_fee, require isMigration=true in mm
    event Migration(uint indexed _summoner, address _from, address _to);
    function migration (uint _summoner, address _owner_new) external payable nonReentrant {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Main mm = Murasaki_Main(ma.address_Murasaki_Main());
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        require(msg.value == mp.PRICE(), 'bad msg.value');
        require(mfs.check_owner(_summoner, msg.sender));
        require(mm.tokenOf(_owner_new) == 0);  //not already possess token
        mm.migration(_summoner, _owner_new);
        payable(ma.address_BufferVault()).transfer(address(this).balance);
        emit Migration(_summoner, msg.sender, _owner_new);
    }
}


//---Feeding_and_Grooming

contract Murasaki_Function_Feeding_and_Grooming is Ownable, ReentrancyGuard, Pausable {

    //pausable
    function pause() external onlyOwner {
        _pause();
    }
    function unpause() external onlyOwner {
        _unpause();
    }

    //address
    address public address_Murasaki_Address;
    function _set_Murasaki_Address(address _address) external onlyOwner {
        address_Murasaki_Address = _address;
    }

    //admin. withdraw
    function withdraw(address rec)public onlyOwner{
        payable(rec).transfer(address(this).balance);
    }
    
    //mapping, last_feeding_time for other user's summoner
    mapping (address => uint) private lastFeedingTime_forOtherSummoner;
    mapping (address => uint) private gained_expAddExtra;
    
    //variants
    uint public feedingInterval_forOtherSummoner = 24 * 60 * 60;
    uint public gainMax_forOtherSummoner = 200;
    uint public satietyAndHappyLimit = 30;
    function _set_feedingInterval_forOtherSummoner(uint _value) external onlyOwner {
        feedingInterval_forOtherSummoner = _value;
    }
    function _set_gainMax_forOtherSummoner(uint _value) external onlyOwner {
        gainMax_forOtherSummoner = _value;
    }
    function _set_satietyAndHappyLimit(uint _value) external onlyOwner {
        satietyAndHappyLimit = _value;
    }
    
    //feeding
    event Feeding(uint indexed _summoner, uint _exp_gained, bool _critical, bool _other);
    function feeding(uint _summoner, uint _item_nui) external nonReentrant whenNotPaused {
        
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        Murasaki_Storage_Score mss = Murasaki_Storage_Score(ma.address_Murasaki_Storage_Score());
        
        require(!mp.isPaused());
        require(ms.inHouse(_summoner));
        //require(mfs.check_owner(_summoner, msg.sender));
        require(not_petrified(_summoner));

        // calc satiety and basic exp
        uint _now = block.timestamp;
        uint _satiety = mfs.calc_satiety(_summoner);
        uint _exp_add = 1000 * (100 - _satiety) / 100;  // 240122 500 -> 1000

        // other check
        bool _other;
        if (!mfs.check_owner(_summoner, msg.sender)) {
            _other = true;
        }

        // when satiety <= 30, others can feed
        require(!_other || (_satiety <= satietyAndHappyLimit));
        
        //twinkle boost, multiplication
        _exp_add = _get_exp_add_from_twinkle(_summoner, _exp_add);
        
        //***TODO*** nui
        // gas reduction is needed
        // nui boost, multiplication with onChain boost
        if (_item_nui > 0) {
            _exp_add = _get_exp_add_from_nui(_summoner, _item_nui, _exp_add);
        }
        
        // when owner, luck challenge
        bool _critical;
        if (!_other) {
            if (mfs.luck_challenge(_summoner)) {
                _exp_add = _exp_add * 2;
                _critical = true;
                _increment_criticalCount(_summoner);
            }
        }
        
        // 0.04@gas
        // when others feed, others get some extra exp and reduce your exp
        if (_other) {
            uint _summoner_yours = mfs.get_summoner(msg.sender);
            if (_summoner_yours != 0) {
                uint _exp_add_extra = _get_exp_add_extra(_exp_add, msg.sender);
                uint _exp_yours = ms.exp(_summoner_yours);
                ms.set_exp(_summoner_yours, _exp_yours + _exp_add_extra);
            }
            _exp_add = _exp_add * 80 / 100;   // 80%
        }

        // update exp and last feeding time
        uint _exp = ms.exp(_summoner) + _exp_add;
        ms.set_exp(_summoner, _exp);
        ms.set_last_feeding_time(_summoner, _now);
        // update score parameters
        uint _total_exp_gained = mss.total_exp_gained(_summoner);
        mss.set_total_exp_gained(_summoner, _total_exp_gained + _exp_add);
        _increment_feedingCount(_summoner);

        // update staking reward counter
        _update_staking_reward_counter(_summoner);
        // event
        emit Feeding(_summoner, _exp_add, _critical, _other);
    }

    function _get_exp_add_extra (uint _exp_add, address _sender) internal returns (uint) {
        
        // calc deltaSec
        uint _now = block.timestamp;
        uint _lastFeedTime = lastFeedingTime_forOtherSummoner[_sender];
        uint _deltaSec = _now - _lastFeedTime;
        
        // when deltaSec >= limit, reset time and point
        if (_deltaSec >= feedingInterval_forOtherSummoner) {
            lastFeedingTime_forOtherSummoner[_sender] = _now;
            gained_expAddExtra[_sender] = 0;
        }
        
        // extra exp = 2%
        // 240207 -> 5%
        uint _exp_add_extra = _exp_add * 5 / 100;
        
        // extra exp limit check
        // 
        // extra exp has an acquisition limit every 24 hr
        if (gained_expAddExtra[_sender] + _exp_add_extra >= gainMax_forOtherSummoner){
            _exp_add_extra = gainMax_forOtherSummoner - gained_expAddExtra[_sender];
        }
        
        // increment total amount of extra exp gained
        gained_expAddExtra[_sender] += _exp_add_extra;
        return _exp_add_extra;
    }
    function _get_exp_add_from_nui(uint _summoner, uint _item_nui, uint _exp_add) internal view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Craft mc = Murasaki_Craft(ma.address_Murasaki_Craft());
        address _owner = mfs.get_owner(_summoner);
        require(mc.ownerOf(_item_nui) == _owner);
        uint _percentx100 = mfs.calc_exp_addition_rate_from_nui(_summoner, _item_nui);
        _exp_add += _exp_add * _percentx100 / 10000;
        return _exp_add;
    }
    function _get_exp_add_from_twinkle(uint _summoner, uint _exp_add) internal view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        uint _percentx100 = mfs.calc_exp_addition_rate_from_twinkle(_summoner);
        _exp_add += _exp_add * _percentx100 / 10000;
        return _exp_add;
    }
    function calc_feeding(uint _summoner) external view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        uint _satiety = mfs.calc_satiety(_summoner);
        uint _exp_add = 500 * (100 - _satiety) / 100;
        return _exp_add;
    }
    function _update_staking_reward_counter(uint _summoner) internal {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Staking_Reward mfsl = Murasaki_Function_Staking_Reward(ma.address_Murasaki_Function_Staking_Reward());
        mfsl.update_staking_counter(_summoner);
    }
    function _increment_feedingCount(uint _summoner) internal {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage_Score mss = Murasaki_Storage_Score(ma.address_Murasaki_Storage_Score());
        uint _total_feeding_count = mss.total_feeding_count(_summoner);
        mss.set_total_feeding_count(_summoner, _total_feeding_count + 1);
        mss.increment_global_total_feeding_count(1);
    }
    function _increment_criticalCount(uint _summoner) internal {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage_Score mss = Murasaki_Storage_Score(ma.address_Murasaki_Storage_Score());
        uint _total_critical_count = mss.total_critical_count(_summoner);
        mss.set_total_critical_count(_summoner, _total_critical_count + 1);
    }

    //petrification, debends on only feeding
    function not_petrified(uint _summoner) internal view returns (bool) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        return mfs.not_petrified(_summoner);
    }
    event Cure_Petrification(uint indexed _summoner, uint _price);
    function cure_petrification(uint _summoner) external payable nonReentrant whenNotPaused {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        require(mfs.check_owner(_summoner, msg.sender));
        require(!not_petrified(_summoner));
        uint PRICE = mp.PRICE();
        // cure cost = present mint price
        require(msg.value >= PRICE);
        uint _now = block.timestamp;
        ms.set_last_feeding_time(_summoner, _now);
        ms.set_working_status(_summoner, 0);
        //fee transfer, same as summon
        payable(ma.address_Coder_Wallet()).transfer(PRICE/20);          //5%
        payable(ma.address_Illustrator_Wallet()).transfer(PRICE/20);    //5%
        payable(ma.address_Staking_Wallet()).transfer(address(this).balance/2);  //45%
        payable(ma.address_BuybackTreasury()).transfer(address(this).balance);   //45%
        //event
        emit Cure_Petrification(_summoner, PRICE);
    }

    //grooming
    event Grooming(uint indexed _summoner, uint _exp_gained, bool _critical);
    function grooming(uint _summoner, uint _item_nui) external nonReentrant whenNotPaused {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        Murasaki_Storage_Score mss = Murasaki_Storage_Score(ma.address_Murasaki_Storage_Score());

        require(mp.isPaused() == false);
        require(ms.inHouse(_summoner));
        //require(mfs.check_owner(_summoner, msg.sender));
        require(not_petrified(_summoner));
        require(ms.working_status(_summoner) == 0);
        
        // calc happy and basic exp
        uint _now = block.timestamp;
        uint _happy = _calc_happy_real(_summoner);
        uint _exp_add = 3000 * (100 - _happy) / 100;
        
        // other check
        bool _other;
        if (!mfs.check_owner(_summoner, msg.sender)) {
            _other = true;
        }
        
        // when happy <= 30, others can feed
        require(!_other || (_happy <= satietyAndHappyLimit));
        
        //twinkle boost, multiplication
        _exp_add = _get_exp_add_from_twinkle(_summoner, _exp_add);
        
        //nui boost, multiplication with onChain boost
        if (_item_nui > 0) {
            _exp_add = _get_exp_add_from_nui(_summoner, _item_nui, _exp_add);
        }

        // when owner, luck challenge
        bool _critical;
        if (!_other) {
            if (mfs.luck_challenge(_summoner)) {
                _exp_add = _exp_add * 2;
                _critical = true;
                _increment_criticalCount(_summoner);
            }
        }

        // when others feed, others get some extra exp and reduce your exp
        if (_other) {
            uint _summoner_yours = mfs.get_summoner(msg.sender);
            if (_summoner_yours != 0) {
                uint _exp_add_extra = _get_exp_add_extra(_exp_add, msg.sender);
                uint _exp_yours = ms.exp(_summoner_yours);
                ms.set_exp(_summoner_yours, _exp_yours + _exp_add_extra);
            }
            _exp_add = _exp_add * 80 / 100;   // 80%
        }

        //add exp
        uint _exp = ms.exp(_summoner) + _exp_add;
        ms.set_exp(_summoner, _exp);
        //update score
        uint _total_exp_gained = mss.total_exp_gained(_summoner);
        mss.set_total_exp_gained(_summoner, _total_exp_gained + _exp_add);
        _increment_groomingCount(_summoner);
        _increment_neglectCount(_summoner);
        //update lastTime
        ms.set_last_grooming_time(_summoner, _now);
        ms.set_last_grooming_time_plus_working_time(_summoner, _now);
        //event
        emit Grooming(_summoner, _exp_add, _critical);
    }

    //calc happy, modified with working_time
    function _calc_happy_real(uint _summoner) internal view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        uint SPEED = mp.SPEED();
        uint BASE_SEC = mp.BASE_SEC();
        uint _now = block.timestamp;
        uint _delta_sec = _now - ms.last_grooming_time_plus_working_time(_summoner);  //working_time
        uint _base = BASE_SEC *3 *100/SPEED;
        uint _happy;
        if (_delta_sec >= _base) {
            _happy = 0;
        }else {
            _happy = 100 * (_base - _delta_sec) / _base;
        }
        //prevent short interval botting
        if (_happy > 0 && _happy < 100) {
            _happy += 1;
        }
        return _happy;
    }
    function calc_grooming(uint _summoner) external view returns (uint) {
        uint _happy = _calc_happy_real(_summoner);
        uint _exp_add = 3000 * (100 - _happy) / 100;
        return _exp_add;
    }
    function _increment_groomingCount(uint _summoner) internal {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage_Score mss = Murasaki_Storage_Score(ma.address_Murasaki_Storage_Score());
        uint _total_grooming_count = mss.total_grooming_count(_summoner);
        mss.set_total_grooming_count(_summoner, _total_grooming_count + 1);
        mss.increment_global_total_grooming_count(1);
    }
    function _increment_neglectCount(uint _summoner) internal {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Storage_Score mss = Murasaki_Storage_Score(ma.address_Murasaki_Storage_Score());
        if (mfs.calc_happy(_summoner) == 0) {
            uint _total_neglect_count = mss.total_neglect_count(_summoner);
            mss.set_total_neglect_count(_summoner, _total_neglect_count + 1);
        }
    }
}


//---Mining_and_Farming

contract Murasaki_Function_Mining_and_Farming is Ownable, ReentrancyGuard, Pausable {

    //pausable
    function pause() external onlyOwner {
        _pause();
    }
    function unpause() external onlyOwner {
        _unpause();
    }

    //address
    address public address_Murasaki_Address;
    function _set_Murasaki_Address(address _address) external onlyOwner {
        address_Murasaki_Address = _address;
    }

    //admin. withdraw
    function withdraw(address rec)public onlyOwner{
        payable(rec).transfer(address(this).balance);
    }

    //mining
    function start_mining(uint _summoner) external nonReentrant whenNotPaused {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        require(mp.isPaused() == false);
        require(ms.inHouse(_summoner));
        require(mfs.check_owner(_summoner, msg.sender));
        require(ms.working_status(_summoner) == 0);
        require(mfs.calc_satiety(_summoner) >= 10 && mfs.calc_happy(_summoner) >= 10);
        require(ms.level(_summoner) >= 2);
        uint _now = block.timestamp;
        //ms.set_mining_status(_summoner, 1);
        ms.set_working_status(_summoner, 1);
        ms.set_mining_start_time(_summoner, _now);
    }
    event Mining(uint indexed _summoner, uint _coin_mined, bool _critical);
    function stop_mining(uint _summoner) external nonReentrant whenNotPaused {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        Murasaki_Storage_Score mss = Murasaki_Storage_Score(ma.address_Murasaki_Storage_Score());
        require(mfs.check_owner(_summoner, msg.sender));
        //require(ms.mining_status(_summoner) == 1);
        require(ms.working_status(_summoner) == 1);
        uint _now = block.timestamp;
        uint _delta = calc_mining(_summoner);
        //luck challenge
        bool _critical;
        if (mfs.luck_challenge(_summoner)) {
            _delta = _delta * 2;
            _critical = true;
        }
        //trial limit, when total>=3000, _delta=0
        if (mfs.isTrial() && mss.total_coin_mined(_summoner) >= 3000) {
            _delta = 0;
        }
        //add coin
        uint _coin = ms.coin(_summoner) + _delta;
        ms.set_coin(_summoner, _coin);
        //update timestamp
        uint _delta_sec = _now - ms.mining_start_time(_summoner);
        uint _last_total_mining_sec = ms.last_total_mining_sec(_summoner) + _delta_sec;
        ms.set_last_total_mining_sec(_summoner, _last_total_mining_sec);
        uint _last_grooming_time_plus_working_time = ms.last_grooming_time_plus_working_time(_summoner) + _delta_sec;
        ms.set_last_grooming_time_plus_working_time(_summoner, _last_grooming_time_plus_working_time);
        //reset status
        ms.set_working_status(_summoner, 0);
        //update score
        uint _total_coin_mined = mss.total_coin_mined(_summoner);
        mss.set_total_coin_mined(_summoner, _total_coin_mined + _delta);
        mss.increment_global_total_coin_mined(_delta);
        //event
        emit Mining(_summoner, _delta, _critical);
    }
    function calc_mining(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        //if (ms.mining_status(_summoner) == 0) {
        if (ms.working_status(_summoner) != 1) {
            return 0;
        }
        address _owner = mfs.get_owner(_summoner);
        uint _now = block.timestamp;
        uint _delta = _now - ms.mining_start_time(_summoner);   //sec
        //happy limit: if happy=0, no more earning
        uint _delta_grooming = _now - ms.last_grooming_time(_summoner);
        uint _base_grooming = mp.BASE_SEC() *3 *100/mp.SPEED();
        if (_delta_grooming >= _base_grooming) {
            _delta = _base_grooming;
        }
        //speed boost
        _delta = _delta * mp.SPEED() / 100;
        //1day = +1000
        _delta = _delta * 1000 / mp.BASE_SEC();
        //status, level, item boost
        uint _mod = ms.strength(_summoner) 
            + ms.level(_summoner)*100 
            + count_mining_items(_owner);
        //5%/point, 100 -> 1.00
        _mod = _mod * 5 / 100;
        //boost
        _delta += _delta * _mod / 100;
        //sparkle boost
        _delta += _delta * count_sparkles(_summoner) / 10000;
        return _delta;
    }
    function calc_mining_perDay (uint _summoner) external view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        uint _mod = ms.strength(_summoner) 
            + ms.level(_summoner)*100 
            + count_mining_items(mfs.get_owner(_summoner));
        _mod = _mod * 5 / 100;  //%
        uint _earn_perDay = 1000 + 1000 * _mod / 100;
        return _earn_perDay;
    }

    function count_mining_items(address _address) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Craft mc = Murasaki_Craft(ma.address_Murasaki_Craft());

        uint _balance_of_type_rare;
        uint _balance_of_type_uncommon;
        uint _balance_of_type_common;

        uint _mining_items = 0;
        for (uint i = 1; i <= 16; i++) {

            _balance_of_type_rare = mc.balance_of_type(_address, i+128);
            _balance_of_type_uncommon = mc.balance_of_type(_address, i+64);
            _balance_of_type_common = mc.balance_of_type(_address, i);

            if (_balance_of_type_rare > 0) {
                _mining_items += 200;
            } else if (_balance_of_type_uncommon > 0) {
                _mining_items += 150;
            } else if (_balance_of_type_common > 0) {
                _mining_items += 100;
            }

            //+10% per one additional item
            if (_balance_of_type_common >= 2) {
                _mining_items += (_balance_of_type_common - 1) * 10;
            }
            if (_balance_of_type_uncommon >= 2) {
                _mining_items += (_balance_of_type_uncommon - 1) * 15;
            }
            if (_balance_of_type_rare >= 2) {
                _mining_items += (_balance_of_type_rare - 1) * 20;
            }
        }
        return _mining_items;
    }
    function count_mining_items_old(address _address) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        uint[320] memory _balance_of_type = mfs.get_balance_of_type_array(_address);
        uint _mining_items = 0;
        for (uint i = 1; i <= 16; i++) {
            if (_balance_of_type[i+128] > 0) {
                _mining_items += 200;
            }else if (_balance_of_type[i+64] > 0) {
                _mining_items += 150;
            }else if (_balance_of_type[i] > 0) {
                _mining_items += 100;
            }
            //+10% per one additional item
            if (_balance_of_type[i] >= 2) {
                _mining_items += (_balance_of_type[i] - 1) * 10;
            }
            if (_balance_of_type[i+64] >= 2) {
                _mining_items += (_balance_of_type[i+64] - 1) * 15;
            }
            if (_balance_of_type[i+128] >= 2) {
                _mining_items += (_balance_of_type[i+128] - 1) * 20;
            }
        }
        return _mining_items;
    }
    
    function count_sparkles (uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        Murasaki_Craft mc = Murasaki_Craft(ma.address_Murasaki_Craft());
        address _owner = mfs.get_owner(_summoner);
        uint _sparkles = 0;
        if (mc.balance_of_type(_owner, 256) > 0) {
            _sparkles += 30;
        }
        if (mc.balance_of_type(_owner, 257) > 0) {
            _sparkles += 60;
        }
        /*
        if (mc.balance_of_type(_owner, 258) > 0) {
            _sparkles += 90;
        }
        if (mc.balance_of_type(_owner, 259) > 0) {
            _sparkles += 120;
        }
        if (mc.balance_of_type(_owner, 260) > 0) {
            _sparkles += 150;
        }
        */
        if (_sparkles > ms.level(_summoner) * 50) {
            _sparkles = ms.level(_summoner) * 50;    // limit: 0.5%/Lv
        }
        return _sparkles;   //percent x 100
    }
    function count_sparkles_old (uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        address _owner = mfs.get_owner(_summoner);
        uint[320] memory _balance_of_type = mfs.get_balance_of_type_array(_owner);
        uint _sparkles = 0;
        if (_balance_of_type[256] > 0) {
            _sparkles += 30;
        } else if (_balance_of_type[257] > 0) {
            _sparkles += 60;
        } else if (_balance_of_type[258] > 0) {
            _sparkles += 90;
        } else if (_balance_of_type[259] > 0) {
            _sparkles += 120;
        } else if (_balance_of_type[260] > 0) {
            _sparkles += 150;
        }
        if (_sparkles > ms.level(_summoner) * 50) {
            _sparkles = ms.level(_summoner) * 50;    // limit: 0.5%/Lv
        }
        return _sparkles;   //percent x 100
    }


    //farming
    function start_farming(uint _summoner) external nonReentrant whenNotPaused {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        require(mp.isPaused() == false);
        require(ms.inHouse(_summoner));
        require(mfs.check_owner(_summoner, msg.sender));
        require(ms.working_status(_summoner) == 0);
        require(mfs.calc_satiety(_summoner) >= 10 && mfs.calc_happy(_summoner) >= 10);
        require(ms.level(_summoner) >= 2);
        uint _now = block.timestamp;
        ms.set_working_status(_summoner, 2);
        ms.set_farming_start_time(_summoner, _now);
    }
    event Farming(uint indexed _summoner, uint _material_farmed, bool _critical);
    function stop_farming(uint _summoner) external nonReentrant whenNotPaused {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        Murasaki_Storage_Score mss = Murasaki_Storage_Score(ma.address_Murasaki_Storage_Score());
        require(mfs.check_owner(_summoner, msg.sender));
        require(ms.working_status(_summoner) == 2);
        uint _now = block.timestamp;
        uint _delta = calc_farming(_summoner);
        //luck challenge
        bool _critical;
        if (mfs.luck_challenge(_summoner)) {
            _delta = _delta * 2;
            _critical = true;
        }
        //trial limit, when total>=3000, _delta=0
        if (mfs.isTrial() && mss.total_material_farmed(_summoner) >= 3000) {
            _delta = 0;
        }
        //add coin
        uint _material = ms.material(_summoner) + _delta;
        ms.set_material(_summoner, _material);
        //update timestamp
        uint _delta_sec = _now - ms.farming_start_time(_summoner);
        uint _last_total_farming_sec = ms.last_total_farming_sec(_summoner) + _delta_sec;
        ms.set_last_total_farming_sec(_summoner, _last_total_farming_sec);
        uint _last_grooming_time_plus_working_time = ms.last_grooming_time_plus_working_time(_summoner) + _delta_sec;
        ms.set_last_grooming_time_plus_working_time(_summoner, _last_grooming_time_plus_working_time);
        //reset status
        ms.set_working_status(_summoner, 0);
        //update score
        uint _total_material_farmed = mss.total_material_farmed(_summoner);
        mss.set_total_material_farmed(_summoner, _total_material_farmed + _delta);
        mss.increment_global_total_material_farmed(_delta);
        //event
        emit Farming(_summoner, _delta, _critical);
    }
    function calc_farming(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        if (ms.working_status(_summoner) != 2) {
            return uint(0);
        }
        address _owner = mfs.get_owner(_summoner);
        uint _now = block.timestamp;
        uint _delta = _now - ms.farming_start_time(_summoner);   //sec
        //happy limit: if happy=0, no more earning
        uint _delta_grooming = _now - ms.last_grooming_time(_summoner);
        uint _base_grooming = mp.BASE_SEC() *3 *100/mp.SPEED();
        if (_delta_grooming >= _base_grooming) {
            _delta = _base_grooming;
        }
        //speed boost
        _delta = _delta * mp.SPEED() / 100;
        //1day = +1000
        _delta = _delta * 1000 / mp.BASE_SEC();
        //status and item boost
        uint _mod = ms.dexterity(_summoner) 
            + ms.level(_summoner)*100 
            + count_farming_items(_owner);
        //5%/point, 100 -> 1.00
        _mod = _mod * 5 / 100;
        //boost
        _delta += _delta * _mod / 100;
        //glitter boost
        _delta += _delta * count_glitter(_summoner) / 10000;
        return _delta;
    }
    function calc_farming_perDay (uint _summoner) external view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        uint _mod = ms.dexterity(_summoner) 
            + ms.level(_summoner)*100 
            + count_farming_items(mfs.get_owner(_summoner));
        _mod = _mod * 5 / 100;  //%
        uint _earn_perDay = 1000 + 1000 * _mod / 100;
        return _earn_perDay;
    }
    function count_farming_items(address _address) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Craft mc = Murasaki_Craft(ma.address_Murasaki_Craft());

        uint _balance_of_type_rare;
        uint _balance_of_type_uncommon;
        uint _balance_of_type_common;

        uint _farming_items = 0;
        for (uint i = 17; i <= 32; i++) {

            _balance_of_type_rare = mc.balance_of_type(_address, i+128);
            _balance_of_type_uncommon = mc.balance_of_type(_address, i+64);
            _balance_of_type_common = mc.balance_of_type(_address, i);

            if (_balance_of_type_rare > 0) {
                _farming_items += 200;
            } else if (_balance_of_type_uncommon > 0) {
                _farming_items += 150;
            } else if (_balance_of_type_common > 0) {
                _farming_items += 100;
            }

            //+10% per one additional item
            if (_balance_of_type_common >= 2) {
                _farming_items += (_balance_of_type_common - 1) * 10;
            }
            if (_balance_of_type_uncommon >= 2) {
                _farming_items += (_balance_of_type_uncommon - 1) * 15;
            }
            if (_balance_of_type_rare >= 2) {
                _farming_items += (_balance_of_type_rare - 1) * 20;
            }
        }
        return _farming_items;
    }
    function count_farming_items_old(address _address) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        uint[320] memory _balance_of_type = mfs.get_balance_of_type_array(_address);
        uint _farming_items = 0;
        for (uint i = 17; i <= 32; i++) {
            if (_balance_of_type[i+128] > 0) {
                _farming_items += 200;
            }else if (_balance_of_type[i+64] > 0) {
                _farming_items += 150;
            }else if (_balance_of_type[i] > 0) {
                _farming_items += 100;
            }
            //+10% per one additional items
            if (_balance_of_type[i] >= 2) {
                _farming_items += (_balance_of_type[i] - 1) * 10;
            }
            if (_balance_of_type[i+64] >= 2) {
                _farming_items += (_balance_of_type[i+64] - 1) * 15;
            }
            if (_balance_of_type[i+128] >= 2) {
                _farming_items += (_balance_of_type[i+128] - 1) * 20;
            }
        }
        return _farming_items;
    }
    function count_glitter (uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        Murasaki_Craft mc = Murasaki_Craft(ma.address_Murasaki_Craft());
        address _owner = mfs.get_owner(_summoner);
        uint _glitters = 0;
        if (mc.balance_of_type(_owner, 261) > 0) {
            _glitters += 30;
        }
        if (mc.balance_of_type(_owner, 262) > 0) {
            _glitters += 60;
        }
        /*
        if (mc.balance_of_type(_owner, 263) > 0) {
            _glitters += 90;
        }
        if (mc.balance_of_type(_owner, 264) > 0) {
            _glitters += 120;
        }
        if (mc.balance_of_type(_owner, 265) > 0) {
            _glitters += 150;
        }
        */
        if (_glitters > ms.level(_summoner) * 50) {
            _glitters = ms.level(_summoner) * 50;    // limit: 0.5%/Lv
        }
        return _glitters;   //percent x 100
    }
    function count_glitter_old (uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        address _owner = mfs.get_owner(_summoner);
        uint[320] memory _balance_of_type = mfs.get_balance_of_type_array(_owner);
        uint _glitters = 0;
        if (_balance_of_type[261] > 0) {
            _glitters += 30;
        } else if (_balance_of_type[262] > 0) {
            _glitters += 60;
        } else if (_balance_of_type[263] > 0) {
            _glitters += 90;
        } else if (_balance_of_type[264] > 0) {
            _glitters += 120;
        } else if (_balance_of_type[265] > 0) {
            _glitters += 150;
        }
        if (_glitters > ms.level(_summoner) * 50) {
            _glitters = ms.level(_summoner) * 50;    // limit: 0.5%/Lv
        }
        return _glitters;   //percent x 100
    }
    
    //forced termination of any working
    function terminate_working (uint _summoner) external {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        require(mp.isPaused() == false);
        require(mfs.check_owner(_summoner, msg.sender));
        require(ms.working_status(_summoner) > 0);
        ms.set_working_status(_summoner, 0);
    }
}


//---Crafting

//item NFT crafting, burn Mail
contract Murasaki_Function_Crafting is Ownable, ReentrancyGuard, Pausable {

    //pausable
    function pause() external onlyOwner {
        _pause();
    }
    function unpause() external onlyOwner {
        _unpause();
    }

    //address
    address public address_Murasaki_Address;
    function _set_Murasaki_Address(address _address) external onlyOwner {
        address_Murasaki_Address = _address;
    }

    //admin. withdraw
    function withdraw(address rec)public onlyOwner{
        payable(rec).transfer(address(this).balance);
    }

    //get modified dc, using codex
    function get_modified_dc(uint _summoner, uint _item_type) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Crafting_Codex mfcc = Murasaki_Function_Crafting_Codex(ma.address_Murasaki_Function_Crafting_Codex());
        return mfcc.get_modified_dc(_summoner, _item_type);
    }
    //calc crafting, using codex
    function calc_crafting(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Crafting_Codex mfcc = Murasaki_Function_Crafting_Codex(ma.address_Murasaki_Function_Crafting_Codex());
        return mfcc.calc_crafting(_summoner);
    }
    //count crafting items, using codex
    function count_crafting_items(address _address) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Crafting_Codex mfcc = Murasaki_Function_Crafting_Codex(ma.address_Murasaki_Function_Crafting_Codex());
        return mfcc.count_crafting_items(_address);
    }
    //get item dc, using codex contract
    function get_item_dc(uint _item_type) public view returns (uint[4] memory) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Crafting_Codex mfcc = Murasaki_Function_Crafting_Codex(ma.address_Murasaki_Function_Crafting_Codex());
        return mfcc.get_item_dc(_item_type);
    }

    //burn, internal
    function _burn(uint _item) internal {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Craft mc = Murasaki_Craft(ma.address_Murasaki_Craft());
        mc.burn(_item);
    }
    //burn mail, external, only from Murasaki_Mail
    function burn_mail(uint _item) external {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        //only from Murasaki_Mail
        require(msg.sender == ma.address_Murasaki_Mail());
        _burn(_item);
    }

    /*  ### crafting comdition ###
                    crafting_status     resume_flag     calc_crafting
        Start               0               0               -
        Pause               1               -               >0
        Resume              0               1               -
        Cancel              0               1               -
        Complete            1               -               ==0
    */

    //start_crafting, resume_flag==0
    function start_crafting(uint _summoner, uint _item_type) external nonReentrant whenNotPaused {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        Murasaki_Storage_Score mss = Murasaki_Storage_Score(ma.address_Murasaki_Storage_Score());
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        require(mp.isPaused() == false);
        require(ms.inHouse(_summoner));
        require(mfs.check_owner(_summoner, msg.sender));
        require(ms.level(_summoner) >= 3);
        require(mfs.calc_satiety(_summoner) >= 10 && mfs.calc_happy(_summoner) >= 10);
        require(ms.working_status(_summoner) == 0);
        require(ms.crafting_resume_flag(_summoner) == 0);        
        //check item_type
        require(_item_type > 0);
        require(
            _item_type <= 64        //normal items
            || _item_type == 194    //coin bag
            || _item_type == 195    //material bag
            || _item_type == 196    //mail
        );
        //trial limitation, only item level=1
        if (mp.isTrial()){
            require(
                mss.total_item_crafted(_summoner) < 3
                && (
                    _item_type == 1
                    || _item_type == 17
                    || _item_type == 33
                )
            );
        }
        //get dc, cost, heart
        uint[4] memory _dc_table = get_item_dc(_item_type);
        uint _coin = _dc_table[2];
        uint _material = _dc_table[3];
        //check coin, material
        require(ms.coin(_summoner) >= _coin);
        require(ms.material(_summoner) >= _material);
        //pay coin, material
        ms.set_coin(_summoner, ms.coin(_summoner) - _coin);
        ms.set_material(_summoner, ms.material(_summoner) - _material);
        //start crafting
        ms.set_crafting_item_type(_summoner, _item_type);
        ms.set_working_status(_summoner, 3);
        ms.set_crafting_start_time(_summoner, block.timestamp);
    }

    //pause_crafting, remining_time > 0
    function pause_crafting(uint _summoner) external nonReentrant whenNotPaused {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        require(mfs.check_owner(_summoner, msg.sender));
        require(ms.working_status(_summoner) == 3);
        require(calc_crafting(_summoner) > 0);
        uint _now = block.timestamp;
        uint _delta_sec = (_now - ms.crafting_start_time(_summoner));
        uint _item_type = ms.crafting_item_type(_summoner);
        //get remining sec
        uint _remining_time = calc_crafting(_summoner);
        //calc remining dc
        uint _remining_dc = _remining_time * 1000 / mp.BASE_SEC();
        //stop
        ms.set_last_total_crafting_sec(
            _summoner, 
            ms.last_total_crafting_sec(_summoner) + _delta_sec
        );
        ms.set_last_grooming_time_plus_working_time(
            _summoner, 
            ms.last_grooming_time_plus_working_time(_summoner) + _delta_sec
        );
        ms.set_working_status(_summoner, 0);
        //pause crafting to resume
        ms.set_crafting_resume_flag(_summoner, 1);
        ms.set_crafting_resume_item_type(_summoner, _item_type);
        ms.set_crafting_resume_item_dc(_summoner, _remining_dc);
    }

    //cancel_crafting, crafting_status==0 & resume_flag==1
    function cancel_crafting(uint _summoner) external nonReentrant whenNotPaused {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        require(mfs.check_owner(_summoner, msg.sender));
        require(ms.working_status(_summoner) == 0);
        require(ms.crafting_resume_flag(_summoner) == 1);
        uint _item_type = ms.crafting_item_type(_summoner);
        //calcel resume
        ms.set_crafting_resume_flag(_summoner, 0);
        //return coin/material
        uint[4] memory _dc_table = get_item_dc(_item_type);
        uint _coin = _dc_table[2];
        uint _material = _dc_table[3];
        ms.set_coin(_summoner, ms.coin(_summoner) + _coin);
        ms.set_material(_summoner, ms.material(_summoner) + _material);
    }

    //resume_crafting, crafting_status==0 & resume_flag==1
    function resume_crafting(uint _summoner) external nonReentrant whenNotPaused {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        require(mp.isPaused() == false);
        require(ms.inHouse(_summoner));
        require(mfs.check_owner(_summoner, msg.sender));
        require(ms.level(_summoner) >= 3);
        require(mfs.calc_satiety(_summoner) >= 10 && mfs.calc_happy(_summoner) >= 10);
        require(ms.working_status(_summoner) == 0);
        require(ms.crafting_resume_flag(_summoner) == 1);
        //resume item_type
        uint _item_type = ms.crafting_resume_item_type(_summoner);
        //check item_type
        require(
            _item_type <= 64        //normal items
            || _item_type == 194    //coin bag
            || _item_type == 195    //material bag
            || _item_type == 196    //mail
        );
        /*  no cost is needed to resume...?
        //get dc, cost, heart
        uint[4] memory _dc_table = get_item_dc(_item_type);
        uint _coin = _dc_table[2];
        uint _material = _dc_table[3];
        //check coin, material, heart
        require(ms.coin(_summoner) >= _coin);
        require(ms.material(_summoner) >= _material);
        //pay coin, material, heart
        ms.set_coin(_summoner, ms.coin(_summoner) - _coin);
        ms.set_material(_summoner, ms.material(_summoner) - _material);
        */
        //start crafting
        ms.set_crafting_item_type(_summoner, _item_type);
        ms.set_working_status(_summoner, 3);
        //ms.set_crafting_status(_summoner, 1);
        ms.set_crafting_start_time(_summoner, block.timestamp);
        //**when resume_flag==1, _resume_dc is used for calc_crafting
    }

    //complete_crafting, crafting_status==1 & remining_time == 0
    event Crafting(uint indexed _summoner, uint _item_type, uint _item, bool _critical);
    function complete_crafting(uint _summoner) external nonReentrant whenNotPaused {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        Murasaki_Craft mc = Murasaki_Craft(ma.address_Murasaki_Craft());
        Murasaki_Storage_Score mss = Murasaki_Storage_Score(ma.address_Murasaki_Storage_Score());
        require(mfs.check_owner(_summoner, msg.sender));
        require(ms.working_status(_summoner) == 3);
        require(calc_crafting(_summoner) == 0);
        uint _now = block.timestamp;
        uint _delta_sec = (_now - ms.crafting_start_time(_summoner));
        uint _item_type = ms.crafting_item_type(_summoner);
        //stop
        ms.set_last_total_crafting_sec(_summoner, ms.last_total_crafting_sec(_summoner) + _delta_sec);
        ms.set_last_grooming_time_plus_working_time(
            _summoner, ms.last_grooming_time_plus_working_time(_summoner) + _delta_sec);
        ms.set_working_status(_summoner, 0);
        //reset resume
        ms.set_crafting_resume_flag(_summoner, 0);
        //craft
        //luck challenge
        bool _critical;
        if (_item_type <= 64 && mfs.luck_challenge(_summoner)) {
            _item_type += 64;
            _critical = true;
            _increment_criticalCount(_summoner);
        }
        //mint
        uint _seed = mfs.seed(_summoner);
        string memory _memo = "";
        mc.craft(_item_type, _summoner, msg.sender, _seed, _memo, 0);
        //when normal items, mint precious and update score
        if (_item_type <= 128) {
            //when trial, does not send presentbox
            if (mfs.isTrial() == false) {
                _send_randomPresentbox(_summoner);
            }
            //first craft bonus
            if (mss.total_item_crafted(_summoner) == 0) {
                _mint_presentbox_firstCraftBonus(msg.sender);
            }
            //update score
            uint _total_item_crafted = mss.total_item_crafted(_summoner);
            mss.set_total_item_crafted(_summoner, _total_item_crafted + 1);
            mss.increment_global_total_item_crafted(1);
        }
        //event
        emit Crafting(_summoner, _item_type, mc.next_item()-1, _critical);
    }
    function _increment_criticalCount(uint _summoner) internal {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage_Score mss = Murasaki_Storage_Score(ma.address_Murasaki_Storage_Score());
        uint _total_critical_count = mss.total_critical_count(_summoner);
        mss.set_total_critical_count(_summoner, _total_critical_count + 1);
    }
    
    //internal, send random presentbox, when complete crafting
    event SendPresentbox(uint indexed _summoner_from, uint _summoner_to);
    function _send_randomPresentbox(uint _summoner_from) internal {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Main mm = Murasaki_Main(ma.address_Murasaki_Main());
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        //get random _to_summoner
        uint _count_summoners = mm.next_token() - 1;
        uint _summoner_to = _summoner_from;
        uint _count = 0;
        //get random, when failed, summoner_to = summoner_from
        while (_count < 5) {
            uint _summoner_tmp = mfs.dn(_summoner_from + _count, _count_summoners) + 1;
            if (
                _summoner_to == _summoner_from
                && ms.isActive(_summoner_tmp)
                && ms.level(_summoner_tmp) >= 3
                && mfs.calc_satiety(_summoner_tmp) >= 10
                && mfs.calc_happy(_summoner_tmp) >= 10
                && _summoner_tmp != _summoner_from
            ) {
                _summoner_to = _summoner_tmp;
            }
            _count += 1;
        }
        address _wallet_to = mm.ownerOf(_summoner_to);
        //mint presentbox
        _mint_presentbox(_summoner_from, _wallet_to);
        //event
        emit SendPresentbox(_summoner_from, _summoner_to);
    }
    
    //internal, mint presentbox
    function _mint_presentbox(uint _summoner_from, address _wallet_to) internal {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Craft mc = Murasaki_Craft(ma.address_Murasaki_Craft());
        uint _seed = mfs.seed(_summoner_from);
        uint _item_type = 200;
        string memory _memo = "item crafting";
        mc.craft(_item_type, _summoner_from, _wallet_to, _seed, _memo, 0);
    }

    //internal, mint presentbox, first craft bonus
    function _mint_presentbox_firstCraftBonus(address _wallet_to) internal {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Craft mc = Murasaki_Craft(ma.address_Murasaki_Craft());
        uint _seed = mfs.seed(0);
        uint _item_type = 200;
        string memory _memo = "first craft bonus";
        mc.craft(_item_type, 0, _wallet_to, _seed, _memo, 0);
    }
    
    //get item name
    function get_item_name(uint _item_type) public view returns (string memory) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Crafting_Codex mfcc = Murasaki_Function_Crafting_Codex(ma.address_Murasaki_Function_Crafting_Codex());
        return mfcc.get_item_name(_item_type);
    }
}


//---Crafting2*

//upgrading, unpack bag/pouch, 
contract Murasaki_Function_Crafting2 is Ownable, ReentrancyGuard, Pausable {

    //pausable
    function pause() external onlyOwner {
        _pause();
    }
    function unpause() external onlyOwner {
        _unpause();
    }

    //address
    address public address_Murasaki_Address;
    function _set_Murasaki_Address(address _address) external onlyOwner {
        address_Murasaki_Address = _address;
    }

    //admin. withdraw
    function withdraw(address rec)public onlyOwner{
        payable(rec).transfer(address(this).balance);
    }

    //get item dc, using codex contract
    function get_item_dc(uint _item_type) public view returns (uint[4] memory) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Crafting_Codex mfcc = Murasaki_Function_Crafting_Codex(ma.address_Murasaki_Function_Crafting_Codex());
        return mfcc.get_item_dc(_item_type);
    }

    //burn, internal
    function _burn(uint _item) internal {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Craft mc = Murasaki_Craft(ma.address_Murasaki_Craft());
        mc.burn(_item);
    }

    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    //upgrade item
    event Upgrade(uint indexed _summoner, uint _item_type, uint _item);
    function upgrade_item(
        uint _summoner, 
        uint _item1, 
        uint _item2, 
        uint _item3
    ) external nonReentrant whenNotPaused {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Craft mc = Murasaki_Craft(ma.address_Murasaki_Craft());
        //check summoner owner
        require(mfs.check_owner(_summoner, msg.sender));
        //check item owner
        require(
            mc.ownerOf(_item1) == msg.sender
            && mc.ownerOf(_item2) == msg.sender
            && mc.ownerOf(_item3) == msg.sender
        );
        //check item_type
        (uint _item_type1, , , , ,) = mc.items(_item1);
        (uint _item_type2, , , , ,) = mc.items(_item2);
        (uint _item_type3, , , , ,) = mc.items(_item3);
        require(_item_type1 <= 128);
        require(
            _item_type2 == _item_type1
            && _item_type3 == _item_type1
        );
        
        //determine target item_type
        uint _target_item_type = _item_type1 +64;
        
        //pay cost, avoid too deep stack error
        _pay_cost(_summoner, _target_item_type);
        
        //burn (transfer) lower rank items
        _burn(_item1);
        _burn(_item2);
        _burn(_item3);
        //mint upper rank item
        uint _seed = mfs.seed(_summoner);
        string memory _memo = "";
        mc.craft(_target_item_type, _summoner, msg.sender, _seed, _memo, 0);
        //event
        emit Upgrade(_summoner, _item_type1, mc.next_item()-1);
    }
    function _pay_cost(uint _summoner, uint _target_item_type) internal {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        //get dc, cost
        uint[4] memory _dc_table = get_item_dc(_target_item_type);
        uint _coin = _dc_table[2];
        uint _material = _dc_table[3];
        //check coin, material
        require(ms.coin(_summoner) >= _coin);
        require(ms.material(_summoner) >= _material);
        //pay coin, material
        ms.set_coin(_summoner, ms.coin(_summoner) - _coin);
        ms.set_material(_summoner, ms.material(_summoner) - _material);
    }

    //upgrade fluffy
    event Upgrade_Fluffy(uint indexed _summoner, uint _item_type, uint _item);
    function upgrade_fluffy(
        uint _summoner,
        uint _item1,
        uint _item2,
        uint _item3,
        uint _item4,
        uint _item5
    ) external nonReentrant whenNotPaused {
        require(_check_summoner(_summoner, msg.sender));
        require(_check_items(_item1, _item2, _item3, _item4, _item5, msg.sender));
        uint _sourceItemType = _get_sourceItemType(_item1);
        uint _targetItemType = _get_targetItemType(_item1);
        _pay_cost(_summoner, _targetItemType);
        _burn_sourceItems(_item1, _item2, _item3, _item4, _item5);
        _mint_item(_summoner, _targetItemType, _sourceItemType, msg.sender);
        uint _present_itemNo = _get_present_itemNo();
        if (_targetItemType >= 237) {
            _update_storage_nui(_summoner, _present_itemNo);
        }
        emit Upgrade_Fluffy(_summoner, _targetItemType, _present_itemNo);        
    }
    function _check_summoner(uint _summoner, address _wallet) internal view returns (bool) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        return mfs.check_owner(_summoner, _wallet);
    }
    function _check_items(
        uint _item1, 
        uint _item2, 
        uint _item3, 
        uint _item4, 
        uint _item5,
        address _wallet
    ) internal view returns (bool) {
        uint _sourceItemType = _get_sourceItemType(_item1);
        uint _targetItemType = _get_targetItemType(_item1);
        //check source item type
        require(201 <= _sourceItemType && _sourceItemType <= 236);
        //when fluffy x5 -> fluffier, require 5 items
        if (213 <= _targetItemType && _targetItemType <= 224) {
            require(_check_item(_item1, _sourceItemType, _wallet));
            require(_check_item(_item2, _sourceItemType, _wallet));
            require(_check_item(_item3, _sourceItemType, _wallet));
            require(_check_item(_item4, _sourceItemType, _wallet));
            require(_check_item(_item5, _sourceItemType, _wallet));
        //when fluffier x4 -> fluffiest, require 4 items
        } else if (224 <= _targetItemType && _targetItemType <= 236) {
            require(_check_item(_item1, _sourceItemType, _wallet));
            require(_check_item(_item2, _sourceItemType, _wallet));
            require(_check_item(_item3, _sourceItemType, _wallet));
            require(_check_item(_item4, _sourceItemType, _wallet));
            require(_item5 == 0);
        //when fluffiest x3 -> nuichan, require 3 items
        //} else if (_targetItemType == 197) {
        } else if (_targetItemType >= 237) {
            require(_check_item(_item1, _sourceItemType, _wallet));
            require(_check_item(_item2, _sourceItemType, _wallet));
            require(_check_item(_item3, _sourceItemType, _wallet));
            require(_item4 == 0);
            require(_item5 == 0);
        }
        return true;
    }
    function _check_item(uint _item, uint _sourceItemType, address _wallet) internal view returns (bool) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Craft mc = Murasaki_Craft(ma.address_Murasaki_Craft());
        (uint _itemType, , , , ,) = mc.items(_item);
        require(_itemType == _sourceItemType);
        require(mfs.check_owner_ofItem(_item, _wallet));
        return true;
    }
    function _get_sourceItemType(uint _sourceItem) internal view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Craft mc = Murasaki_Craft(ma.address_Murasaki_Craft());
        (uint _sourceItemType, , , , ,) = mc.items(_sourceItem);
        return _sourceItemType;
    }
    function _get_targetItemType(uint _sourceItem) internal view returns (uint) {
        uint _sourceItemType = _get_sourceItemType(_sourceItem);
        uint _targetItemType;
        // when fluffy or fluffier, +12
        if (201 <= _sourceItemType && _sourceItemType <= 224) {
            _targetItemType = _sourceItemType +12;
        // when fluffiest, -> nui-chan
        } else if (225 <= _sourceItemType && _sourceItemType <= 236) {
            //_targetItemType = 197;
            _targetItemType = _sourceItemType +12;
        }
        return _targetItemType;
    }
    function _burn_sourceItems(
        uint _item1, 
        uint _item2, 
        uint _item3,
        uint _item4,
        uint _item5
    ) internal {
        _burn(_item1);
        _burn(_item2);
        _burn(_item3);
        if (_item4 != 0) {
            _burn(_item4);
        }
        if (_item5 != 0) {
            _burn(_item5);
        }
    }
    function _mint_item(
        uint _summoner,
        uint _targetItemType,
        uint _sourceItemType,
        address _wallet
    ) internal {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Craft mc = Murasaki_Craft(ma.address_Murasaki_Craft());
        uint _seed = mfs.seed(_summoner);
        string memory _memo = toString(_sourceItemType);    //memo source fluffy type
        mc.craft(_targetItemType, _summoner, _wallet, _seed, _memo, 0);
    }
    function _get_present_itemNo() internal view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Craft mc = Murasaki_Craft(ma.address_Murasaki_Craft());
        return mc.next_item() - 1;
    }
    function _update_storage_nui(uint _summoner, uint _item_nui) internal {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Main mm = Murasaki_Main(ma.address_Murasaki_Main());
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        Murasaki_Storage_Score mss = Murasaki_Storage_Score(ma.address_Murasaki_Storage_Score());
        Murasaki_Storage_Nui msn = Murasaki_Storage_Nui(ma.address_Murasaki_Storage_Nui());
        uint _now = block.timestamp;
        //set status
        msn.set_mint_time(_item_nui, _now);
        msn.set_summoner(_item_nui, _summoner);
        msn.set_class(_item_nui, mm.class(_summoner));
        msn.set_level(_item_nui, ms.level(_summoner));
        msn.set_strength(_item_nui, ms.strength(_summoner));
        msn.set_dexterity(_item_nui, ms.dexterity(_summoner));
        msn.set_intelligence(_item_nui, ms.intelligence(_summoner));
        msn.set_luck(_item_nui, ms.luck(_summoner));
        msn.set_total_exp_gained(_item_nui, mss.total_exp_gained(_summoner));
        msn.set_total_coin_mined(_item_nui, mss.total_coin_mined(_summoner));
        msn.set_total_material_farmed(_item_nui, mss.total_material_farmed(_summoner));
        msn.set_total_item_crafted(_item_nui, mss.total_item_crafted(_summoner));
        msn.set_total_precious_received(_item_nui, mss.total_precious_received(_summoner));
        msn.set_score(_item_nui, mfs.calc_score(_summoner));
    }
    
    //unpack coin/material
    event Unpack(uint indexed _summoner, uint _item_type, uint _item);
    function unpack_bag (uint _summoner, uint _item) external nonReentrant whenNotPaused {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        Murasaki_Craft mc = Murasaki_Craft(ma.address_Murasaki_Craft());
        //check owner
        require(mfs.check_owner(_summoner, msg.sender));
        require(mc.ownerOf(_item) == msg.sender);
        //check item_type
        (uint _item_type, , , , ,) = mc.items(_item);
        require(_item_type == 194 || _item_type == 195);
        //burn _item
        _burn(_item);
        //unpack coin/material
        if (_item_type == 194) {
            ms.set_coin(_summoner, ms.coin(_summoner) + 1000);
        } else if (_item_type == 195) {
            ms.set_material(_summoner, ms.material(_summoner) + 1000);
        }
        //event
        emit Unpack(_summoner, _item_type, _item);
    }
    
    //open present box and mint precious
    //presentbox = 200
    event Open_Presentbox(uint indexed _summoner, uint _item, uint crafted_summoner);
    function open_presentbox (uint _summoner, uint _item) external nonReentrant whenNotPaused {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Craft mc = Murasaki_Craft(ma.address_Murasaki_Craft());
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        Murasaki_Storage_Score mss = Murasaki_Storage_Score(ma.address_Murasaki_Storage_Score());
        //check owner
        require(mfs.check_owner(_summoner, msg.sender));
        require(mc.ownerOf(_item) == msg.sender);
        //check item_type
        (uint _item_type, , uint crafted_summoner, , ,) = mc.items(_item);
        require(_item_type == 200);
        //burn _item
        _burn(_item);
        //mint precious
        //need: summoner_to, summoner_from, to_wallet
        _mint_precious(_summoner, crafted_summoner, msg.sender);
        //add some exp
        uint _exp_add = mp.EXP_FROM_PRESENTBOX();
        uint _exp = ms.exp(_summoner) + _exp_add;
        ms.set_exp(_summoner, _exp);
        //update score
        uint _total_exp_gained = mss.total_exp_gained(_summoner) + _exp_add;
        mss.set_total_exp_gained(_summoner, _total_exp_gained);
        emit Open_Presentbox(_summoner, _item, crafted_summoner);
    }
    //mint precious
    event Fluffy(uint indexed _summoner_to, uint _summoner_from, uint _item_type);
    function _mint_precious(uint _summoner_to, uint _summoner_from, address _wallet_to) internal {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Craft mc = Murasaki_Craft(ma.address_Murasaki_Craft());
        Murasaki_Storage_Score mss = Murasaki_Storage_Score(ma.address_Murasaki_Storage_Score());
        //mint precious
        uint _seed = mfs.seed(_summoner_from);
        uint _item_type = 200 + mfs.d12(_summoner_from) + 1;   //201-212
        string memory _memo = "";
        mc.craft(_item_type, _summoner_from, _wallet_to, _seed, _memo, 0);
        //update score
        uint _total_precious_received = mss.total_precious_received(_summoner_to);
        mss.set_total_precious_received(_summoner_to, _total_precious_received + 1);
        mss.increment_global_total_precious_received(1);
        //event
        emit Fluffy(_summoner_to, _summoner_from, _item_type);
    }
}


//---Crafting_Codex

contract Murasaki_Function_Crafting_Codex is Ownable, Pausable {

    //pausable
    function pause() external onlyOwner {
        _pause();
    }
    function unpause() external onlyOwner {
        _unpause();
    }

    //address
    address public address_Murasaki_Address;
    function _set_Murasaki_Address(address _address) external onlyOwner {
        address_Murasaki_Address = _address;
    }

    //calc crafting
    /*  ### pattern ###
        crafting_status     resume_flag     _remining_time
               0                 0                0
               0                 1         dc * BASE_SEC/1000
               1                 0            calc from item_dc
               1                 1            calc from resume_dc
    */
    function calc_crafting(uint _summoner) public view whenNotPaused returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        //when crafting=0 & resume_flag=0, return 0
        if (
            ms.working_status(_summoner) != 3 
            && ms.crafting_resume_flag(_summoner) == 0
        ) {
            return 0;
        //when crafting=0 & resume_flag=1, remining sec
        } else if (
            ms.working_status(_summoner) != 3 
            && ms.crafting_resume_flag(_summoner) == 1
        ) {
            uint BASE_SEC = mp.BASE_SEC();
            uint _dc = ms.crafting_resume_item_dc(_summoner);
            return _dc * BASE_SEC/1000;
        //when crafting=1 & resume_flag=0, calc from item_dc
        } else if (
            ms.working_status(_summoner) == 3
            && ms.crafting_resume_flag(_summoner) == 0
        ) {
            return _calc_crafting_noResume(_summoner);
        //when crafting=1 & resume_flag=1, calc from resume_dc
        } else if (
            ms.working_status(_summoner) == 3 
            && ms.crafting_resume_flag(_summoner) == 1
        ) {
            return _calc_crafting_resume(_summoner);
        }
        return 0;
    }
    function _calc_crafting_noResume(uint _summoner) internal view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        uint _item_type = ms.crafting_item_type(_summoner);
        //## get modified dc ##
        uint _dc = get_modified_dc(_summoner, _item_type);
        //calc remaining sec
        uint _dc_sec = _dc * mp.BASE_SEC() / 1000;   //1000dc = 1day = 86400sec
        //calc remining sec
        uint _remining_time;
        uint _delta_time = ( block.timestamp - ms.crafting_start_time(_summoner) ) * mp.SPEED()/100;

        // 240427 added
        // happy limit, if happy=0, _delta_time=base_groming_sec
        uint _delta_grooming = block.timestamp - ms.last_grooming_time(_summoner);
        uint _base_grooming = mp.BASE_SEC() *3 *100/mp.SPEED();
        if (_delta_grooming >= _base_grooming) {
            _delta_time = _base_grooming;
        }
        
        // calc reming sec
        if (_delta_time >= _dc_sec) {
            _remining_time = 0;
        }else {
            _remining_time = _dc_sec - _delta_time;
        }
        return _remining_time;        
    }
    function _calc_crafting_resume(uint _summoner) internal view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        //## get resume_dc ##
        uint _dc = ms.crafting_resume_item_dc(_summoner);
        //calc remaining sec
        uint _dc_sec = _dc * mp.BASE_SEC() / 1000;   //1000dc = 1day = 86400sec
        //calc remining sec
        uint _remining_time;
        uint _delta_time = ( block.timestamp - ms.crafting_start_time(_summoner) ) * mp.SPEED()/100;

        // 240508 added
        // happy limit, if happy=0, _delta_time=base_groming_sec
        uint _delta_grooming = block.timestamp - ms.last_grooming_time(_summoner);
        uint _base_grooming = mp.BASE_SEC() *3 *100/mp.SPEED();
        if (_delta_grooming >= _base_grooming) {
            _delta_time = _base_grooming;
        }

        if (_delta_time >= _dc_sec) {
            _remining_time = 0;
        }else {
            _remining_time = _dc_sec - _delta_time;
        }
        return _remining_time;
    }

    //get modified_dc
    function get_modified_dc(uint _summoner, uint _item_type) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        address _owner = mfs.get_owner(_summoner);
        uint[4] memory _dc_table = get_item_dc(_item_type);
        //get dc
        uint _level = _dc_table[0];
        uint _dc = _dc_table[1];
        // when not normal items: return exact dc
        if (_item_type >= 192) {
            return _dc;
        // when normal crafting items: modified by status
        } else {
            //status boost
            //uint _mod = ms.intelligence(_summoner) + ms.level(_summoner)*100 + count_crafting_items(msg.sender);
            uint _mod = ms.intelligence(_summoner) + ms.level(_summoner)*100 + count_crafting_items(_owner);
            //initial point = 400 (1Lv*100, 3INT*100)
            //point per level = 150 (1Lv*100 + 0.5INT*100)
            //minimum dc = 3000 (3 days)
            // _mod_dc = _dc - ( _dc / (_level * 150) ) * (_mod - 400) >= 3000
            // _delta = (_mod - 400) / (_level * 150) * _dc
            // _mod_dc = _dc - _delta >= 3000
            //uint _delta = (_mod - 400) / (_level * 150) * _dc;  //original concept law, but not good
            //uint _delta = _dc * (_mod - 400) / (_level * 150);    //division should be done last
            uint _delta = _dc * (_mod - 400) / (_level * 300);    //150 -> 300, 220401
            uint _mod_dc;
            //dc limit check
            if (_dc < dc_limit_table[_item_type] + _delta) {
                _mod_dc = dc_limit_table[_item_type];
            } else {
                _mod_dc = _dc - _delta;
            }
            return _mod_dc;
        }
    }

    //count crafting items
    function count_crafting_items(address _address) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Craft mc = Murasaki_Craft(ma.address_Murasaki_Craft());

        uint _balance_of_type_rare;
        uint _balance_of_type_uncommon;
        uint _balance_of_type_common;

        uint _crafting_items = 0;
        for (uint i = 33; i <= 48; i++) {

            _balance_of_type_rare = mc.balance_of_type(_address, i+128);
            _balance_of_type_uncommon = mc.balance_of_type(_address, i+64);
            _balance_of_type_common = mc.balance_of_type(_address, i);

            if (_balance_of_type_rare > 0) {
                _crafting_items += 200;
            } else if (_balance_of_type_uncommon > 0) {
                _crafting_items += 150;
            } else if (_balance_of_type_common > 0) {
                _crafting_items += 100;
            }

            //+10% per one additional item
            if (_balance_of_type_common >= 2) {
                _crafting_items += (_balance_of_type_common - 1) * 10;
            }
            if (_balance_of_type_uncommon >= 2) {
                _crafting_items += (_balance_of_type_uncommon - 1) * 15;
            }
            if (_balance_of_type_rare >= 2) {
                _crafting_items += (_balance_of_type_rare - 1) * 20;
            }
        }
        return _crafting_items;
    }
    function count_crafting_items_old(address _address) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        uint[320] memory _balance_of_type = mfs.get_balance_of_type_array(_address);
        uint _crafting_items = 0;
        for (uint i = 33; i <= 48; i++) {
            if (_balance_of_type[i+128] > 0) {
                _crafting_items += 200;
            }else if (_balance_of_type[i+64] > 0) {
                _crafting_items += 150;
            }else if (_balance_of_type[i] > 0) {
                _crafting_items += 100;
            }
            //+10% per one additional items
            if (_balance_of_type[i] >= 2) {
                _crafting_items += (_balance_of_type[i] - 1) * 10;
            }
            if (_balance_of_type[i+64] >= 2) {
                _crafting_items += (_balance_of_type[i+64] - 1) * 15;
            }
            if (_balance_of_type[i+128] >= 2) {
                _crafting_items += (_balance_of_type[i+128] - 1) * 20;
            }
        }
        return _crafting_items;
    }

    //get item dc
    function get_item_dc(uint _item_type) public view returns (uint[4] memory) {
        //return: level, dc, coin, material
        uint _level = 999999;
        uint _dc = 999999;
        uint _coin = 999999;
        uint _material = 999999;

        // for crafting
        //194: coin bag
        if (_item_type == 194){
            _level = 99;
            _dc = 40;    //30min
            _coin = 1200;
            _material = 100;
        //195: material bag
        } else if (_item_type == 195) {
            _level = 99;
            _dc = 40;
            _coin = 100;
            _material = 1200;
        //196: mail
        } else if (_item_type == 196) {
            _level = 99;
            _dc = 20;
            _coin = 100;
            _material = 100;
        //1-64: normal items
        } else if (_item_type <= 64) {
            _level = level_table[_item_type];
            _dc = dc_table[_item_type];
            _coin = coin_table[_item_type];
            _material = material_table[_item_type];
            
        // for upgrading
        //65-127: common -> uncommon
        } else if (_item_type >= 65 && _item_type <= 128) {
            _coin = 200;
            _material = 200;
        //129-192: uncommon -> rare
        } else if (_item_type >= 129 && _item_type <= 192) {
            _coin = 400;
            _material = 400;
        //213-224: fluffy -> fluffier
        } else if (_item_type >= 213 && _item_type <= 224) {
            _coin = 200;
            _material = 200;
        //225-236: fluffier -> fluffiest
        } else if (_item_type >= 225 && _item_type <= 236) {
            _coin = 400;
            _material = 400;
        //237-248: fluffiest -> nui
        } else if (_item_type >= 237 && _item_type <= 248) {
            _coin = 600;
            _material = 600;
        }
        return [_level, _dc, _coin, _material];
    }
    
    //get item name
    function get_item_name(uint _item_type) public view returns (string memory) {
        return item_name_table[_item_type];
    }

    //item level
    uint[64] public level_table = [
        //0:dummy
        9999999999,
        //1-16: mining item
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10,
        11,
        12,
        13,
        14,
        15,
        16,
        //17-32: farming item
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10,
        11,
        12,
        13,
        14,
        15,
        16,
        //33-48: crafting item
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10,
        11,
        12,
        13,
        14,
        15,
        16,
        //49-63: unreserved
        99,
        99,
        99,
        99,
        99,
        99,
        99,
        99,
        99,
        99,
        99,
        99,
        99,
        99,
        99
    ];

    //item dc
    uint[64] public dc_table = [
        //0:dummy
        9999999999,
        //1-16: mining item
        3000,
        6000,
        10000,
        15000,
        21000,
        28000,
        36000,
        45000,
        55000,
        66000,
        78000,
        91000,
        105000,
        120000,
        136000,
        153000,
        //17-32: farming item
        3000,
        6000,
        10000,
        15000,
        21000,
        28000,
        36000,
        45000,
        55000,
        66000,
        78000,
        91000,
        105000,
        120000,
        136000,
        153000,
        //33-48: crafting item
        3000,
        6000,
        10000,
        15000,
        21000,
        28000,
        36000,
        45000,
        55000,
        66000,
        78000,
        91000,
        105000,
        120000,
        136000,
        153000,
        //49-63: unreserved
        9999999,
        9999999,
        9999999,
        9999999,
        9999999,
        9999999,
        9999999,
        9999999,
        9999999,
        9999999,
        9999999,
        9999999,
        9999999,
        9999999,
        9999999
    ];
    
    //item dc limit
    uint[64] public dc_limit_table = [
        //0:dummy
        9999999999,
        //1-16: mining item
        3000 / 3,
        3000 / 3 * 2,
        3000,
        3000,
        3000,
        3000,
        3000,
        3000,
        4000,
        4000,
        4000,
        4000,
        5000,
        5000,
        6000,
        7000,
        //17-32: farming item
        3000 / 3,
        3000 / 3 * 2,
        3000,
        3000,
        3000,
        3000,
        3000,
        3000,
        4000,
        4000,
        4000,
        4000,
        5000,
        5000,
        6000,
        7000,
        //33-48: crafting item
        3000 / 3,
        3000 / 3 * 2,
        3000,
        3000,
        3000,
        3000,
        3000,
        3000,
        4000,
        4000,
        4000,
        4000,
        5000,
        5000,
        6000,
        7000,
        //49-63: unreserved
        9999999,
        9999999,
        9999999,
        9999999,
        9999999,
        9999999,
        9999999,
        9999999,
        9999999,
        9999999,
        9999999,
        9999999,
        9999999,
        9999999,
        9999999
    ];

    //item coin
    uint[64] public coin_table = [
        //0:dummy
        9999999999,
        //1-16: mining item
        3000 / 3,
        3600 / 3 * 2,
        4050,
        4500,
        4950,
        5400,
        5850,
        6300,
        6750 * 4/3,
        7200 * 4/3,
        7650 * 4/3,
        8100 * 4/3,
        8550 * 5/3,
        9000 * 5/3,
        9450 * 6/3,
        9900 * 7/3,
        //17-32: farming item
        300 / 3,
        360 / 3 * 2,
        405,
        450,
        495,
        540,
        585,
        630,
        675 * 4/3,
        720 * 4/3,
        765 * 4/3,
        810 * 4/3,
        855 * 5/3,
        900 * 5/3,
        945 * 6/3,
        990 * 7/3,
        //33-48: crafting item
        1500 / 3,
        1800 / 3 * 2,
        2025,
        2250,
        2475,
        2700,
        2925,
        3150,
        3375 * 4/3,
        3600 * 4/3,
        3825 * 4/3,
        4050 * 4/3,
        4275 * 5/3,
        4500 * 5/3,
        4725 * 6/3,
        4950 * 7/3,
        //49-63: unreserved
        99999,
        99999,
        99999,
        99999,
        99999,
        99999,
        99999,
        99999,
        99999,
        99999,
        99999,
        99999,
        99999,
        99999,
        99999
    ];

    //item material
    uint[64] public material_table = [
        //0:dummy
        9999999999,
        //1-16: mining item
        300 / 3,
        360 / 3 * 2,
        405,
        450,
        495,
        540,
        585,
        630,
        675 * 4/3,
        720 * 4/3,
        765 * 4/3,
        810 * 4/3,
        855 * 5/3,
        900 * 5/3,
        945 * 6/3,
        990 * 7/3,
        //17-32: farming item
        3000 / 3,
        3600 / 3 * 2,
        4050,
        4500,
        4950,
        5400,
        5850,
        6300,
        6750 * 4/3,
        7200 * 4/3,
        7650 * 4/3,
        8100 * 4/3,
        8550 * 5/3,
        9000 * 5/3,
        9450 * 6/3,
        9900 * 7/3,
        //33-48: crafting item
        1500 / 3,
        1800 / 3 * 2,
        2025,
        2250,
        2475,
        2700,
        2925,
        3150,
        3375 * 4/3,
        3600 * 4/3,
        3825 * 4/3,
        4050 * 4/3,
        4275 * 5/3,
        4500 * 5/3,
        4725 * 6/3,
        4950 * 7/3,
        //49-63: unreserved
        99999,
        99999,
        99999,
        99999,
        99999,
        99999,
        99999,
        99999,
        99999,
        99999,
        99999,
        99999,
        99999,
        99999,
        99999
    ];
    

    //item name
    string[320] public item_name_table = [
    
        //## item name

        //0:dummy
        "",
    
        //1-16
        "Nameplate",
        "Mr. Astar",
        "Onigiri",
        "Helmet",
        "Lucky Dice",
        "Wall Sticker",
        "Hammock",
        "Token Chest",
        "Knit Hat",
        "House of Fluffy",
        "Crown",
        "Clarinet",
        "Horn",
        "Cake",
        "Fortune Statue",
        "Door of Travel",

        //17-32
        "Music Box",
        "Straw Hat",
        "Score Meter",
        "Ms. Ether",
        "Rug-Pull",
        "Window",
        "Cat Cushion",
        "Picture Frame",
        "Crayon",
        "Pancake",
        "Fishbowl",
        "Piano",
        "Timpani",
        "Pinwheel",
        "Asnya",
        "Key to Travel",

        //33-48
        "Tablet",
        "Choco Bread",
        "Flower Wreath",
        "Ribbon",
        "Dr. Bitco",
        "Light Switch",
        "Mortarboard",
        "News Board",
        "Water Bottle",
        "Diary Book",
        "Cuckoo Clock",
        "Violin",
        "Harp",
        "Flowerpot",
        "Lantern",
        "Travel Bag",

        //49-64
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",

        //65-80
        "Uncommon Nameplate",
        "Uncommon Mr. Astar",
        "Uncommon Onigiri",
        "Uncommon Helmet",
        "Uncommon Dice",
        "Uncommon Wall Sticker",
        "Uncommon Hammock",
        "Uncommon Token Chest",
        "Uncommon Knit Hat",
        "Uncommon House of Fluffy",
        "Uncommon Crown",
        "Uncommon Clarinet",
        "Uncommon Horn",
        "Uncommon Cake",
        "Uncommon Fortune Statue",
        "Uncommon Door of Travel",

        //81-96
        "Uncommon Music Box",
        "Uncommon Straw Hat",
        "Uncommon Score Meter",
        "Uncommon Ms. Ether",
        "Uncommon Rug-Pull",
        "Uncommon Window",
        "Uncommon Cat Cushion",
        "Uncommon Picture Frame",
        "Uncommon Crayon",
        "Uncommon Pancake",
        "Uncommon Fishbowl",
        "Uncommon Piano",
        "Uncommon Timpani",
        "Uncommon Pinwheel",
        "Uncommon Asnya",
        "Uncommon Key to Travel",

        //97-112
        "Uncommon Tablet",
        "Uncommon Choco Bread",
        "Uncommon Flower Wreath",
        "Uncommon Ribbon",
        "Uncommon Dr. Bitco",
        "Uncommon Light Switch",
        "Uncommon Mortarboard",
        "Uncommon News Board",
        "Uncommon Water Bottle",
        "Uncommon Diary Book",
        "Uncommon Cuckoo Clock",
        "Uncommon Violin",
        "Uncommon Harp",
        "Uncommon Flowerpot",
        "Uncommon Lantern",
        "Uncommon Travel Bag",

        //113-128
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",

        //129-144
        "Rare Nameplate",
        "Rare Mr. Astar",
        "Rare Onigiri",
        "Rare Helmet",
        "Rare Dice",
        "Rare Wall Sticker",
        "Rare Hammock",
        "Rare Token Chest",
        "Rare Knit Hat",
        "Rare House of Fluffy",
        "Rare Crown",
        "Rare Clarinet",
        "Rare Horn",
        "Rare Cake",
        "Rare Fortune Statue",
        "Rare Door of Travel",

        //145-160
        "Rare Music Box",
        "Rare Straw Hat",
        "Rare Score Meter",
        "Rare Ms. Ether",
        "Rare Rug-Pull",
        "Rare Window",
        "Rare Cat Cushion",
        "Rare Picture Frame",
        "Rare Crayon",
        "Rare Pancake",
        "Rare Fishbowl",
        "Rare Piano",
        "Rare Timpani",
        "Rare Pinwheel",
        "Rare Asnya",
        "Rare Key to Travel",

        //161-176
        "Rare Tablet",
        "Rare Choco Bread",
        "Rare Flower Wreath",
        "Rare Ribbon",
        "Rare Dr. Bitco",
        "Rare Light Switch",
        "Rare Mortarboard",
        "Rare News Board",
        "Rare Water Bottle",
        "Rare Diary Book",
        "Rare Cuckoo Clock",
        "Rare Violin",
        "Rare Harp",
        "Rare Flowerpot",
        "Rare Lantern",
        "Rare Travel Bag",

        //177-192
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",

        //193
        "",
        //194
        "Coin Bank",
        //195
        "Leaf Pouch",
        //196
        "Cat Mail",
        //197
        //"Fluffy Murasaki-San",
        "",
        //198
        "",
        //199
        "",
        //200
        "Present Box",
        
        //201-212
        "Gray Fluffy",
        "Beige Fluffy",
        "Limegreen Fluffy",
        "Lightblue Fluffy",
        "Blue Fluffy",
        "Purple Fluffy",
        "Redpurple Fluffy",
        "Red Fluffy",
        "Orange Fluffy",
        "Pink Fluffy",
        "Yellow Fluffy",
        "White Fluffy",
        
        //213-224
        "Gray Fluffier",
        "Beige Fluffier",
        "Limegreen Fluffier",
        "Lightblue Fluffier",
        "Blue Fluffier",
        "Purple Fluffier",
        "Redpurple Fluffier",
        "Red Fluffier",
        "Orange Fluffier",
        "Pink Fluffier",
        "Yellow Fluffier",
        "White Fluffier",

        //225-236
        "Gray Fluffiest",
        "Beige Fluffiest",
        "Limegreen Fluffiest",
        "Lightblue Fluffiest",
        "Blue Fluffiest",
        "Purple Fluffiest",
        "Redpurple Fluffiest",
        "Red Fluffiest",
        "Orange Fluffiest",
        "Pink Fluffiest",
        "Yellow Fluffiest",
        "White Fluffiest",

        //237-248
        "Gray Doll",
        "Beige Doll",
        "Limegreen Doll",
        "Lightblue Doll",
        "Blue Doll",
        "Purple Doll",
        "Redpurple Doll",
        "Red Doll",
        "Orange Doll",
        "Pink Doll",
        "Yellow Doll",
        "White Doll",
        
        //249-250
        "",
        "",
        
        //251-255, twinkle
        "Chipped Twinkle",
        "Flawed Twinkle",
        "Regular Twinkle",
        "Flawless Twinkle",
        "Perfect Twinkle",
        
        //256-260, sparkle
        "Chipped Sparkle",
        "Flawed Sparkle",
        "Regular Sparkle",
        "Flawless Sparkle",
        "Perfect Sparkle",

        //261-265, glitter
        "Chipped Glitter",
        "Flawed Glitter",
        "Regular Glitter",
        "Flawless Glitter",
        "Perfect Glitter",

        //265-270
        "",
        "",
        "",
        "",
        "",

        //271-280
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",

        //281-290
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",

        //291-300
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",

        //301-310
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",

        //311-319
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        ""
    ];
}


//---Name

contract Murasaki_Function_Name is Ownable, ReentrancyGuard, Pausable {

    //pausable
    function pause() external onlyOwner {
        _pause();
    }
    function unpause() external onlyOwner {
        _unpause();
    }

    //address
    address public address_Murasaki_Address;
    function _set_Murasaki_Address(address _address) external onlyOwner {
        address_Murasaki_Address = _address;
    }

    //admin, withdraw
    function withdraw(address rec)public onlyOwner{
        payable(rec).transfer(address(this).balance);
    }
    
    //## item types
    //nameplate item_type
    uint public nameplate_item_type = 1;
    //set dice item_type
    function _set2_nameplate_item_type(uint _item_type) external onlyOwner {
        nameplate_item_type = _item_type;
    }

    //mint
    event Name(uint indexed _summoner, string _name_str, uint _name_id);
    function mint(uint _summoner, string memory _name_str) external nonReentrant whenNotPaused {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Name mn = Murasaki_Name(ma.address_Murasaki_Name());
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        require(mp.isPaused() == false);
        //owner check
        require(mfs.check_owner(_summoner, msg.sender));
        //check nameplate possession
        address _owner = mfs.get_owner(_summoner);
        require(
            mfs.get_balance_of_type_specific(_owner, nameplate_item_type) > 0
            || mfs.get_balance_of_type_specific(_owner, nameplate_item_type +64) > 0
            || mfs.get_balance_of_type_specific(_owner, nameplate_item_type +128) > 0
        );
        //name check
        require(validate_name(_name_str));
        require(mn.isMinted(_name_str) == false);
        //level check
        require(ms.level(_summoner) >= 3);
        //cost check
        uint _coin = 100;
        uint _material = 100;
        require(ms.coin(_summoner) >= _coin && ms.material(_summoner) >= _material);
        //pay cost
        ms.set_coin(_summoner, ms.coin(_summoner) - _coin);
        ms.set_material(_summoner, ms.material(_summoner) - _material);
        //mint
        uint _seed = mfs.seed(_summoner);
        mn.mint(msg.sender, _name_str, _seed);
        //event
        //emit Name(_summoner, _name_str, mn.next_name());
        emit Name(_summoner, _name_str, mn.next_token()-1);
    }

    //burn
    event Burn(uint indexed _summoner, uint _name_id);
    function burn(uint _summoner) external nonReentrant whenNotPaused {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Name mn = Murasaki_Name(ma.address_Murasaki_Name());
        require(mfs.check_owner(_summoner, msg.sender));
        address _owner = mfs.get_owner(_summoner);
        uint _name_id = mn.tokenOf(_owner);
        require(_name_id > 0);
        mn.burn(_name_id);
        //event
        emit Burn(_summoner, _name_id);
    }

    //call_name_from_summoner
    function call_name_from_summoner(uint _summoner) external view returns (string memory) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Name mn = Murasaki_Name(ma.address_Murasaki_Name());
        address _owner = mfs.get_owner(_summoner);
        uint _name_id = mn.tokenOf(_owner);
        string memory _name_str = mn.names(_name_id);
        return _name_str;
    }

    // from rarity_names
    // indentifying large and small capital
    // @dev Check if the name string is valid (Alphanumeric and spaces without leading or trailing space)
    function validate_name(string memory str) public pure returns (bool){
        bytes memory b = bytes(str);
        if(b.length < 1) return false;
        //if(b.length > 25) return false; // Cannot be longer than 25 characters
        if(b.length > 12) return false; // Cannot be longer than 12 characters
        if(b[0] == 0x20) return false; // Leading space
        if (b[b.length - 1] == 0x20) return false; // Trailing space
        bytes1 last_char = b[0];
        for(uint i; i<b.length; i++){
            bytes1 char = b[i];
            //if (char == 0x20 && last_char == 0x20) return false; // Cannot contain continous spaces
            if (char == 0x20) return false; // Cannot contain any spaces
            if(
                !(char >= 0x30 && char <= 0x39) && //9-0
                !(char >= 0x41 && char <= 0x5A) && //A-Z
                !(char >= 0x61 && char <= 0x7A) && //a-z
                !(char == 0x20) //space
            )
                return false;
            last_char = char;
        }
        return true;
    }
}


//---Achievement

contract Murasaki_Function_Achievement is Ownable, Pausable {

    //pausable
    function pause() external onlyOwner {
        _pause();
    }
    function unpause() external onlyOwner {
        _unpause();
    }

    //address
    address public address_Murasaki_Address;
    function _set_Murasaki_Address(address _address) external onlyOwner {
        address_Murasaki_Address = _address;
    }

    //get_achv
    function get_achievement (uint _summoner) external view whenNotPaused returns (bool[32] memory) {
        bool[32] memory _achievements;
        for (uint _achv_id=1; _achv_id<32; _achv_id++) {
            _achievements[_achv_id] = _check_achievement(_summoner, _achv_id);
        }
        return _achievements;
    }
    
    //get count of achv
    function get_countOf_achievement (uint _summoner) external view returns (uint) {
        uint _count = 0;
        bool _res;
        for (uint _achv_id=1; _achv_id<32; _achv_id++) {
            _res = _check_achievement(_summoner, _achv_id);
            if (_res == true) {
                _count += 1;
            }
        }
        return _count;
    }

    //internal, check_achv
    function _check_achievement(uint _summoner, uint _achievement_id) internal view returns (bool) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage_Score mss = Murasaki_Storage_Score(ma.address_Murasaki_Storage_Score());
        //1: total_coin > 10000
        if (_achievement_id == 1) {
            if (mss.total_coin_mined(_summoner) >= 10000) {
                return true;
            }
        //2: total_coin > 30000
        } else if (_achievement_id == 2) {
            if (mss.total_coin_mined(_summoner) >= 30000) {
                return true;
            }
        //3: total_coin > 100000
        } else if (_achievement_id == 3) {
            if (mss.total_coin_mined(_summoner) >= 100000) {
                return true;
            }
        //4: total_coin > 300000
        } else if (_achievement_id == 4) {
            if (mss.total_coin_mined(_summoner) >= 300000) {
                return true;
            }
        //5: total_coin > 1000000
        } else if (_achievement_id == 5) {
            if (mss.total_coin_mined(_summoner) >= 1000000) {
                return true;
            }
        //6: total_material > 10000
        } else if (_achievement_id == 6) {
            if (mss.total_material_farmed(_summoner) >= 10000) {
                return true;
            }
        //7: total_material > 30000
        } else if (_achievement_id == 7) {
            if (mss.total_material_farmed(_summoner) >= 30000) {
                return true;
            }
        //8: total_material > 100000
        } else if (_achievement_id == 8) {
            if (mss.total_material_farmed(_summoner) >= 100000) {
                return true;
            }
        //9: total_material > 300000
        } else if (_achievement_id == 9) {
            if (mss.total_material_farmed(_summoner) >= 300000) {
                return true;
            }
        //10: total_material > 1000000
        } else if (_achievement_id == 10) {
            if (mss.total_material_farmed(_summoner) >= 1000000) {
                return true;
            }
        //11: total_item > 5
        } else if (_achievement_id == 11) {
            if (mss.total_item_crafted(_summoner) >= 5) {
                return true;
            }
        //12: total_item > 10
        } else if (_achievement_id == 12) {
            if (mss.total_item_crafted(_summoner) >= 10) {
                return true;
            }
        //13: total_item > 20
        } else if (_achievement_id == 13) {
            if (mss.total_item_crafted(_summoner) >= 20) {
                return true;
            }
        //14: total_item > 40
        } else if (_achievement_id == 14) {
            if (mss.total_item_crafted(_summoner) >= 40) {
                return true;
            }
        //15: total_item > 80
        } else if (_achievement_id == 15) {
            if (mss.total_item_crafted(_summoner) >= 80) {
                return true;
            }
        //16: total_fluffy > 30
        } else if (_achievement_id == 16) {
            if (mss.total_precious_received(_summoner) >= 30) {
                return true;
            }
        //17: total_fluffy > 60
        } else if (_achievement_id == 17) {
            if (mss.total_precious_received(_summoner) >= 60) {
                return true;
            }
        //18: total_fluffy > 120
        } else if (_achievement_id == 18) {
            if (mss.total_precious_received(_summoner) >= 120) {
                return true;
            }
        //19: total_fluffy > 240
        } else if (_achievement_id == 19) {
            if (mss.total_precious_received(_summoner) >= 240) {
                return true;
            }
        //20: total_fluffy > 480
        } else if (_achievement_id == 20) {
            if (mss.total_precious_received(_summoner) >= 480) {
                return true;
            }
        }
        return false;
    }
}


//---Music_Practice

contract Murasaki_Function_Music_Practice is Ownable, ReentrancyGuard, Pausable {

    //pausable
    function pause() external onlyOwner {
        _pause();
    }
    function unpause() external onlyOwner {
        _unpause();
    }

    //address
    address public address_Murasaki_Address;
    function _set_Murasaki_Address(address _address) external onlyOwner {
        address_Murasaki_Address = _address;
    }
    
    //## item types
    uint item_type_clarinet = 13;
    uint item_type_piano = 29;
    uint item_type_violin = 45;
    uint item_type_horn = 999;
    uint item_type_timpani = 999;
    uint item_type_harp = 999;
    uint required_level = 5;
    
    //admin modify item types
    function _set_item_type_clarinet(uint _value) external onlyOwner {
        item_type_clarinet = _value;
    }
    function _set_item_type_piano(uint _value) external onlyOwner {
        item_type_piano = _value;
    }
    function _set_item_type_violin(uint _value) external onlyOwner {
        item_type_violin = _value;
    }
    function _set_item_type_horn(uint _value) external onlyOwner {
        item_type_horn = _value;
    }
    function _set_item_type_timpani(uint _value) external onlyOwner {
        item_type_timpani = _value;
    }
    function _set_item_type_harp(uint _value) external onlyOwner {
        item_type_harp = _value;
    }
    function _set_required_level(uint _value) external onlyOwner {
        required_level = _value;
    }

    //start practice
    function start_practice(uint _summoner, uint _item_id) external nonReentrant whenNotPaused {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        require(_check_summoner(_summoner, msg.sender));
        require(_check_item(_item_id, msg.sender));
        require(ms.working_status(_summoner) == 0);
        require(mfs.calc_satiety(_summoner) >= 10 && mfs.calc_happy(_summoner) >= 10);
        require(ms.level(_summoner) >= required_level);
        ms.set_working_status(_summoner, 4);
        ms.set_practice_item_id(_summoner, _item_id);
        ms.set_practice_start_time(_summoner, block.timestamp);
    }
    
    //stop practice
    event Practice(uint indexed _summoner, uint _itemType, uint _exp);
    function stop_practice(uint _summoner) external nonReentrant whenNotPaused {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        Murasaki_Storage_Score mss = Murasaki_Storage_Score(ma.address_Murasaki_Storage_Score());
        require(_check_summoner(_summoner, msg.sender));
        require(ms.working_status(_summoner) == 4);
        ms.set_working_status(_summoner, 0);
        //get item_type used in practice
        uint _item_id = ms.practice_item_id(_summoner);
        uint _item_type = _get_item_type(_item_id);
        //calc exp
        uint _exp = _calc_exp(_summoner);
        //boost exp by item rarity
        _exp = _get_exp_mod_byRarity(_exp, _item_type);
        //boost exp by status point and update exp
        if (_item_type == item_type_clarinet) {
            _exp = _get_exp_mod_ofClarinet(_summoner, _exp);
            ms.set_exp_clarinet(_summoner, ms.exp_clarinet(_summoner) + _exp);
            mss.increment_global_total_practiceTime_clarinet(_exp);
        } else if (_item_type == item_type_piano) {
            _exp = _get_exp_mod_ofPiano(_summoner, _exp);
            ms.set_exp_piano(_summoner, ms.exp_piano(_summoner) + _exp);
            mss.increment_global_total_practiceTime_piano(_exp);
        } else if (_item_type == item_type_violin) {
            _exp = _get_exp_mod_ofViolin(_summoner, _exp);
            ms.set_exp_violin(_summoner, ms.exp_violin(_summoner) + _exp);
            mss.increment_global_total_practiceTime_violin(_exp);
        }
        //event
        emit Practice(_summoner, _item_type, _exp);
        //update last_grooming_time_plus_working_time
        uint _delta_sec = block.timestamp - ms.practice_start_time(_summoner);
        uint _last_grooming_time_plus_working_time = 
            ms.last_grooming_time_plus_working_time(_summoner) + _delta_sec;
        ms.set_last_grooming_time_plus_working_time(
            _summoner, 
            _last_grooming_time_plus_working_time
        );
        //reset parameters
        ms.set_practice_item_id(_summoner, 0);
        ms.set_practice_start_time(_summoner, 0);
    }
    
    //internal: calc delta_sec
    function _calc_delta_sec (uint _summoner) internal view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        uint _now = block.timestamp;
        uint _delta = _now - ms.practice_start_time(_summoner);
        //check happy
        uint _delta_grooming = _now - ms.last_grooming_time(_summoner);
        uint _base_grooming = mp.BASE_SEC() *3 *100/mp.SPEED();
        if (_delta_grooming >= _base_grooming) {
            _delta = _base_grooming;
        }
        //speed boost
        _delta = _delta * mp.SPEED() / 100;
        return _delta;
    }

    //internal: calc exp
    function _calc_exp (uint _summoner) internal view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        uint _now = block.timestamp;
        uint _delta = _now - ms.practice_start_time(_summoner);
        //check happy
        uint _delta_grooming = _now - ms.last_grooming_time(_summoner);
        uint _base_grooming = mp.BASE_SEC() *3 *100/mp.SPEED();
        if (_delta_grooming >= _base_grooming) {
            _delta = _base_grooming;
        }
        //speed boost
        _delta = _delta * mp.SPEED() / 100;
        //1000exp = 1day
        uint _exp = _delta * 1000 / mp.BASE_SEC();
        return _exp;
    }
    
    //internal: get item_type
    function _get_item_type(uint _item_id) internal view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Craft mc = Murasaki_Craft(ma.address_Murasaki_Craft());
        (uint _item_type, , , , ,) = mc.items(_item_id);
        // uncommon, rare -> common
        if (_item_type >= 129) {
            _item_type -= 128;
        } else if (_item_type >= 65) {
            _item_type -= 64;
        }
        return _item_type;
    }
    
    //internal: check summoner
    function _check_summoner(uint _summoner, address _wallet) internal view returns (bool) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        require(mp.isPaused() == false);
        require(ms.inHouse(_summoner));
        require(mfs.check_owner(_summoner, _wallet));
        require(mfs.not_petrified(_summoner));
        return true;
    }
    
    //internal: check item
    function _check_item(uint _item_id, address _wallet) internal view returns (bool) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Craft mc = Murasaki_Craft(ma.address_Murasaki_Craft());
        require(mfs.check_owner_ofItem(_item_id, _wallet));
        (uint _item_type, , , , ,) = mc.items(_item_id);
        require(
            _item_type == item_type_clarinet
            || _item_type == item_type_piano
            || _item_type == item_type_violin
            || _item_type == item_type_horn
            || _item_type == item_type_timpani
            || _item_type == item_type_harp
        );
        return true;
    }
    
    //internal: get exp_mod by item_rarity
    //common: +0%, uncommon: +10%, rare: +20% exp
    function _get_exp_mod_byRarity(uint _exp, uint _item_type) internal pure returns (uint) {
        if (_item_type >= 129) {
            return _exp * 120 / 100;
        } else if (_item_type >= 65) {
            return _exp * 110 / 100;
        } else {
            return _exp;
        }
    }
    
    //internal: get exp_mod by status
    // +1% per 1 status point, STR, DEX, INT
    function _get_exp_mod_ofClarinet(uint _summoner, uint _exp) internal view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Info mi = Murasaki_Info(ma.address_Murasaki_Info());
        _exp += _exp * mi.strength_withItems(_summoner) / 10000;
        return _exp;
    }
    function _get_exp_mod_ofPiano(uint _summoner, uint _exp) internal view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Info mi = Murasaki_Info(ma.address_Murasaki_Info());
        _exp += _exp * mi.dexterity_withItems(_summoner) / 10000;
        return _exp;
    }
    function _get_exp_mod_ofViolin(uint _summoner, uint _exp) internal view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Info mi = Murasaki_Info(ma.address_Murasaki_Info());
        _exp += _exp * mi.intelligence_withItems(_summoner) / 10000;
        return _exp;
    }
    function _get_exp_mod_ofHorn(uint _summoner, uint _exp) internal view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Info mi = Murasaki_Info(ma.address_Murasaki_Info());
        _exp += _exp * mi.strength_withItems(_summoner) / 10000;
        return _exp;
    }
    function _get_exp_mod_ofTimpani(uint _summoner, uint _exp) internal view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Info mi = Murasaki_Info(ma.address_Murasaki_Info());
        _exp += _exp * mi.dexterity_withItems(_summoner) / 10000;
        return _exp;
    }
    function _get_exp_mod_ofHarp(uint _summoner, uint _exp) internal view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Info mi = Murasaki_Info(ma.address_Murasaki_Info());
        _exp += _exp * mi.intelligence_withItems(_summoner) / 10000;
        return _exp;
    }
    
    //get practice level of each instrument
    function get_practiceLevel_clarinet (uint _summoner) external view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        return _calc_level_from_exp(ms.exp_clarinet(_summoner));
    }
    function get_practiceLevel_piano (uint _summoner) external view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        return _calc_level_from_exp(ms.exp_piano(_summoner));
    }
    function get_practiceLevel_violin (uint _summoner) external view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        return _calc_level_from_exp(ms.exp_violin(_summoner));
    }
    function get_practiceLevel_horn (uint _summoner) external view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        return _calc_level_from_exp(ms.exp_horn(_summoner));
    }
    function get_practiceLevel_timpani (uint _summoner) external view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        return _calc_level_from_exp(ms.exp_timpani(_summoner));
    }
    function get_practiceLevel_harp (uint _summoner) external view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        return _calc_level_from_exp(ms.exp_harp(_summoner));
    }
    
    //internal: calc level from exp
    function _calc_level_from_exp(uint _exp) internal pure returns (uint) {
        //Lv2=5000, Lv3=Lv2+5000, Lv4=Lv3+5000+delta_add(=2000)*1
        uint _level = 0;
        if (_exp == 0) {
            _level = 0;
        } else if (_exp < 5000) {
            _level = 1;
        } else if (_exp < 10000) {
            _level = 2;
        } else if (_exp < 17000) {
            _level = 3;
        } else if (_exp < 26000) {
            _level = 4;
        } else if (_exp < 37000) {
            _level = 5;
        } else if (_exp < 50000) {
            _level = 6;
        } else if (_exp < 65000) {
            _level = 7;
        } else if (_exp < 82000) {
            _level = 8;
        } else if (_exp < 101000) {
            _level = 9;
        } else if (_exp < 122000) {
            _level = 10;
        } else if (_exp < 145000) {
            _level = 11;
        } else if (_exp < 170000) {
            _level = 12;
        } else if (_exp < 197000) {
            _level = 13;
        } else if (_exp < 226000) {
            _level = 14;
        } else if (_exp < 257000) {
            _level = 15;
        } else if (_exp < 290000) {
            _level = 16;
        } else if (_exp < 325000) {
            _level = 17;
        } else if (_exp < 362000) {
            _level = 18;
        } else if (_exp < 401000) {
            _level = 19;
        } else if (_exp >= 401000) {
            _level = 20;
        }
        return _level;
    }
}


//---Staking_Reward

// DappsStaking interface for EVM
// 0x0000000000000000000000000000000000005001
interface IDappsStaking {
    function read_contract_stake (address) external view returns (uint128);
    function read_staked_amount (bytes memory) external view returns (uint128);
    function read_staked_amount_on_contract (address, bytes memory) external view returns (uint128);
}

contract Murasaki_Function_Staking_Reward is Ownable, ReentrancyGuard, Pausable {

    //pausable
    function pause() external onlyOwner {
        _pause();
    }
    function unpause() external onlyOwner {
        _unpause();
    }

    //address
    address public address_Murasaki_Address;
    function _set_Murasaki_Address(address _address) external onlyOwner {
        address_Murasaki_Address = _address;
    }
    
    //get staking amount WASM + EVM
    function get_staking_amount (uint _summoner) public view returns (uint) {
        return (get_staking_amount_wasm(_summoner) + get_staking_amount_evm(_summoner));
    }
    
    //get staking amount WASM
    function get_staking_amount_wasm (uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        //trial limit, no amount
        if (mfs.isTrial()) {
            return 0;
        }
        address _owner = mfs.get_owner(_summoner);
        IAstarBase ASTARBASE = IAstarBase(ma.address_AstarBase());
        uint _staker_raw = ASTARBASE.checkStakerStatusOnContract(_owner, ma.address_Murasaki_Main());
        uint _staker = _staker_raw / (10 ** 18);
        return _staker;
    }
    
    // 230911: support for EVM dapps staking
    //get staking amount EVM
    function get_staking_amount_evm (uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        //trial limit, no amount
        if (mfs.isTrial()) {
            return 0;
        }
        address _owner = mfs.get_owner(_summoner);
        IDappsStaking DappsStaking = IDappsStaking(0x0000000000000000000000000000000000005001);
        uint _staker_raw = DappsStaking.read_staked_amount_on_contract(
            ma.address_Murasaki_Main(), 
            _addressToBytes(_owner)
        );
        uint _staker = _staker_raw / (10 ** 18);
        return _staker;
    }
    function _addressToBytes(address _address) internal pure returns (bytes memory) {
        bytes20 convertedBytes = bytes20(_address);
        return abi.encodePacked(convertedBytes);
    }
       
    //get staking counter speed
    function get_staking_counter_speed (uint _summoner) public view returns (uint) {
        uint _staker = get_staking_amount(_summoner);
        uint _speed;
        // 241114, updated
        if (_staker < 500) {
            _speed = 0;
        } else if (_staker < 1000) {
            _speed = 102;
        } else if (_staker < 2000) {
            _speed = 103;
        } else if (_staker < 3000) {
            _speed = 107;
        } else if (_staker < 4000) {
            _speed = 113;
        } else if (_staker < 5000) {
            _speed = 126;
        } else if (_staker < 6000) {
            _speed = 146;
        } else if (_staker < 7000) {
            _speed = 172;
        } else if (_staker < 8000) {
            _speed = 205;
        } else if (_staker < 9000) {
            _speed = 244;
        } else if (_staker < 10000) {
            _speed = 297;
        } else if (_staker < 20000) {
            _speed = 362;
        } else if (_staker < 30000) {
            _speed = 379;
        } else if (_staker < 40000) {
            _speed = 395;
        } else if (_staker < 50000) {
            _speed = 408;
        } else if (_staker < 75000) {
            _speed = 418;
        } else if (_staker < 100000) {
            _speed = 425;
        } else if (_staker >= 100000) {
            _speed = 428;
        }
        return _speed;
    }
    
    //get present staking counter
    function get_staking_counter (uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        return ms.staking_reward_counter(_summoner);
    }
    
    //get staking reword percent
    function get_staking_percent (uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        uint _counter = get_staking_counter(_summoner);
        uint _percent = 0;
        if (_counter == mp.STAKING_REWARD_SEC()){
            _percent = 0;
        } else if (_counter == 0) {
            _percent = 100;
        } else {
            _percent = (mp.STAKING_REWARD_SEC() - _counter) * 100 / mp.STAKING_REWARD_SEC();
            //_percent =  _counter * 100 / mp.STAKING_REWARD_SEC();
        }
        return _percent;
    }
    
    //update staking counter
    //can be exected by direct contract access
    function update_staking_counter (uint _summoner) external nonReentrant whenNotPaused {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        //only from mffg
        //require(msg.sender == ma.address_Murasaki_Function_Feeding_and_Grooming());
        uint _delta_sec = block.timestamp - ms.last_counter_update_time(_summoner);
        _delta_sec = _delta_sec * mp.SPEED() / 100;
        //delta_sec limit, <= 1/2 day
        if (_delta_sec > 43200) {
            _delta_sec = 43200;
        }
        uint _speed = get_staking_counter_speed(_summoner);
        if (_speed > 0) {
            uint _decrease = _speed * _delta_sec / 100;
            uint _counter = ms.staking_reward_counter(_summoner);
            //decrease counter sec
            if (_counter > _decrease) {
                _counter = _counter - _decrease;
                ms.set_staking_reward_counter(_summoner, _counter);
            //when counter <= 0, set counter=0
            } else {
                ms.set_staking_reward_counter(_summoner, 0);
            }
            //update total_counter
            ms.set_total_staking_reward_counter(
                _summoner,
                ms.total_staking_reward_counter(_summoner) + _decrease
            );
        }
        //update last update time, both speed>0 & speed=0
        ms.set_last_counter_update_time(_summoner, block.timestamp);
    }
    
    //chekc open staking reword
    function check_open_staking_reward (uint _summoner) public view returns (bool) {
        bool _bool = false;
        if (get_staking_percent(_summoner) == 100) {
            _bool = true;
        }
        return _bool;
    }
    
    event Staking_Reward(uint indexed _summoner, string _reward);
    function open_staking_reward (uint _summoner) external nonReentrant whenNotPaused {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        //check owner
        require(mfs.check_owner(_summoner, msg.sender));
        //check counter=0
        require(check_open_staking_reward(_summoner));
        //mint random nft
        uint _rnd = mfs.d100(_summoner);
        string memory _reward = "";
        if (_rnd < 3) {
            _mint_twinkleSparkleGlitter(_summoner, 251);
            _reward = "twinkle";
        } else if (_rnd < 6) {
            _mint_twinkleSparkleGlitter(_summoner, 256);
            _reward = "sparkle";
        } else if (_rnd < 9) {
            _mint_twinkleSparkleGlitter(_summoner, 261);
            _reward = "glitter";
        } else if (_rnd < 19) {
            _mint_fluffier(_summoner);
            _reward = "fluffier";
        } else if (_rnd < 29) {
            _mint_bank(_summoner);
            _reward = "piggy bank";
        } else if (_rnd < 39) {
            _mint_pouch(_summoner);
            _reward = "leaf pouch";
        } else {
            _mint_fluffy(_summoner);
            _reward = "fluffy";
        }
        //reset counter
        ms.set_staking_reward_counter(_summoner, mp.STAKING_REWARD_SEC());
        //event
        emit Staking_Reward(_summoner, _reward);
    }
    //mint fluffy
    function _mint_fluffy(uint _summoner_to) internal {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Craft mc = Murasaki_Craft(ma.address_Murasaki_Craft());
        Murasaki_Storage_Score mss = Murasaki_Storage_Score(ma.address_Murasaki_Storage_Score());
        //mint precious
        address _owner = mfs.get_owner(_summoner_to);
        uint _seed = mfs.seed(_summoner_to);
        uint _item_type = 200 + mfs.d12(_summoner_to) + 1;   //201-212
        string memory _memo = "staking reword";
        mc.craft(_item_type, 0, _owner, _seed, _memo, 0);
        //update score
        uint _total_precious_received = mss.total_precious_received(_summoner_to);
        mss.set_total_precious_received(_summoner_to, _total_precious_received + 1);
        mss.increment_global_total_precious_received(1);
    }
    //mint fluffier
    function _mint_fluffier(uint _summoner_to) internal {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Craft mc = Murasaki_Craft(ma.address_Murasaki_Craft());
        Murasaki_Storage_Score mss = Murasaki_Storage_Score(ma.address_Murasaki_Storage_Score());
        //mint precious
        address _owner = mfs.get_owner(_summoner_to);
        uint _seed = mfs.seed(_summoner_to);
        uint _item_type = 200 + mfs.d12(_summoner_to) + 1 +12;   //213-224
        string memory _memo = "staking reword";
        mc.craft(_item_type, 0, _owner, _seed, _memo, 0);
        //update score
        uint _total_precious_received = mss.total_precious_received(_summoner_to);
        mss.set_total_precious_received(_summoner_to, _total_precious_received + 5);
        mss.increment_global_total_precious_received(5);
    }
    //mint bank
    function _mint_bank(uint _summoner_to) internal {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Craft mc = Murasaki_Craft(ma.address_Murasaki_Craft());
        //mint precious
        address _owner = mfs.get_owner(_summoner_to);
        uint _seed = mfs.seed(_summoner_to);
        uint _item_type = 194;
        string memory _memo = "staking reword";
        mc.craft(_item_type, 0, _owner, _seed, _memo, 0);
    }
    //mint pouch
    function _mint_pouch(uint _summoner_to) internal {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Craft mc = Murasaki_Craft(ma.address_Murasaki_Craft());
        //mint precious
        address _owner = mfs.get_owner(_summoner_to);
        uint _seed = mfs.seed(_summoner_to);
        uint _item_type = 195;
        string memory _memo = "staking reword";
        mc.craft(_item_type, 0, _owner, _seed, _memo, 0);
    }
    //mint twinkle:251, sparkle:256, glitter:261
    function _mint_twinkleSparkleGlitter (uint _summoner_to, uint _item_type) internal {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Craft mc = Murasaki_Craft(ma.address_Murasaki_Craft());
        //mint precious
        address _owner = mfs.get_owner(_summoner_to);
        uint _seed = mfs.seed(_summoner_to);
        uint _item_subtype = mfs.d12(_seed + _summoner_to);
        string memory _memo = "staking reword";
        mc.craft(_item_type, 0, _owner, _seed, _memo, _item_subtype);
    }
}


//---Trial_Converter

contract Trial_Converter is Ownable, ReentrancyGuard, Pausable {

    // pausable
    function pause() external onlyOwner {
        _pause();
    }
    function unpause() external onlyOwner {
        _unpause();
    }

    // address
    // *NOTICE* trial address_Murasaki_Address
    address public address_Murasaki_Address;
    function _set_Murasaki_Address(address _address) external onlyOwner {
        address_Murasaki_Address = _address;
    }

    //admin. withdraw
    function withdraw(address rec)public onlyOwner{
        payable(rec).transfer(address(this).balance);
    }
    
    //converting summon
    event ConvertingSummon(uint indexed _summoner, uint _trial_summoner);
    function converting_summon () external nonReentrant payable whenNotPaused {
        //check not paused
        require(_check_notPaused());
        //only trial
        require(_check_trial());
        //prepare wallet and summoner
        address _wallet = msg.sender;
        uint _trial_summoner = _tokenOf(_wallet);
        //check wallet: token possess check
        require(_check_wallet(_wallet));
        //check cost payment
        require(_check_payment(msg.value));
        //summon regular summoner
        uint _summoner = _summon_regular_summoner_and_convert_mm(_trial_summoner, _wallet);
        //convert ms, mss
        _convert_ms(_trial_summoner, _summoner);
        _convert_mss(_trial_summoner, _summoner);
        //convert all item NFTs
        _mint_and_convert_mc(_wallet);
        //burn trial summoner
        _burn_trial_summoner(_trial_summoner);
        //bonus presentbox
        _mint_presentbox(_trial_summoner, _wallet);
        //fee transfer
        _fee_transfer();
        //event
        emit ConvertingSummon(_summoner, _trial_summoner);
    }
    
    //internal functions
    function _check_notPaused () internal view returns (bool) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        return !mp.isPaused();
    }
    function _tokenOf (address _wallet) internal view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Main mm = Murasaki_Main(ma.address_Murasaki_Main());
        return mm.tokenOf(_wallet);
    }
    function _check_wallet (address _wallet) internal view returns (bool) {
        Murasaki_Address ma_trial = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Main mm = Murasaki_Main(ma_trial.address_Murasaki_Main());
        Murasaki_Address ma_reg = Murasaki_Address(ma_trial.address_Murasaki_Address_Regular());
        Murasaki_Main mm_reg = Murasaki_Main(ma_reg.address_Murasaki_Main());
        bool _res;
        //possess trial_summoner and not possess regular_summoner
        if (
            mm.tokenOf(_wallet) != 0
            && mm_reg.tokenOf(_wallet) == 0
        ) {
            _res = true;
        }
        return _res;
    }
    function _check_trial () internal view returns (bool) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        return mp.isTrial();
    }
    function _check_payment (uint _msg_value) internal view returns (bool) {
        Murasaki_Address ma_trial = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Address ma_reg = Murasaki_Address(ma_trial.address_Murasaki_Address_Regular());
        Murasaki_Parameter mp_reg = Murasaki_Parameter(ma_reg.address_Murasaki_Parameter());
        bool _res;
        if (_msg_value >= mp_reg.PRICE()){
            _res = true;
        }
        return _res;
    }
    function _summon_regular_summoner_and_convert_mm (
        uint _trial_summoner,
        address _wallet
    ) internal returns (uint) {
        Murasaki_Address ma_trial = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Address ma_reg = Murasaki_Address(ma_trial.address_Murasaki_Address_Regular());
        Murasaki_Main mm_trial = Murasaki_Main(ma_trial.address_Murasaki_Main());
        Murasaki_Main mm_reg = Murasaki_Main(ma_reg.address_Murasaki_Main());
        uint _summoner = mm_reg.next_token();
        uint _class = mm_trial.class(_trial_summoner);
        uint _seed = mm_trial.seed(_trial_summoner);
        //summon regular summoner
        mm_reg.summon(_wallet, _class, _seed);
        //convert summoned_time
        uint _summoned_time = mm_trial.summoned_time(_trial_summoner);
        mm_reg.set_summoned_time(_summoner, _summoned_time);
        return _summoner;
    }
    function _convert_ms (uint _trial_summoner, uint _summoner) internal {
        Murasaki_Address ma_trial = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Address ma_reg = Murasaki_Address(ma_trial.address_Murasaki_Address_Regular());
        Murasaki_Storage ms_trial = Murasaki_Storage(ma_trial.address_Murasaki_Storage());
        Murasaki_Storage ms_reg = Murasaki_Storage(ma_reg.address_Murasaki_Storage());
        ms_reg.set_level(_summoner, ms_trial.level(_trial_summoner));
        ms_reg.set_exp(_summoner, ms_trial.exp(_trial_summoner));
        ms_reg.set_strength(_summoner, ms_trial.strength(_trial_summoner));
        ms_reg.set_dexterity(_summoner, ms_trial.dexterity(_trial_summoner));
        ms_reg.set_intelligence(_summoner, ms_trial.intelligence(_trial_summoner));
        ms_reg.set_luck(_summoner, ms_trial.luck(_trial_summoner));
        ms_reg.set_next_exp_required(_summoner, ms_trial.next_exp_required(_trial_summoner));
        ms_reg.set_last_level_up_time(_summoner, ms_trial.last_level_up_time(_trial_summoner));
        ms_reg.set_coin(_summoner, ms_trial.coin(_trial_summoner));
        ms_reg.set_material(_summoner, ms_trial.material(_trial_summoner));
        ms_reg.set_last_feeding_time(_summoner, ms_trial.last_feeding_time(_trial_summoner));
        ms_reg.set_last_grooming_time(_summoner, ms_trial.last_grooming_time(_trial_summoner));
        ms_reg.set_working_status(_summoner, ms_trial.working_status(_trial_summoner));
        //ms_reg.set_mining_status(_summoner, ms_trial.mining_status(_trial_summoner));
        ms_reg.set_mining_start_time(_summoner, ms_trial.mining_start_time(_trial_summoner));
        //ms_reg.set_farming_status(_summoner, ms_trial.farming_status(_trial_summoner));
        ms_reg.set_farming_start_time(_summoner, ms_trial.farming_start_time(_trial_summoner));
        //ms_reg.set_crafting_status(_summoner, ms_trial.crafting_status(_trial_summoner));
        ms_reg.set_crafting_start_time(_summoner, ms_trial.crafting_start_time(_trial_summoner));
        ms_reg.set_crafting_item_type(_summoner, ms_trial.crafting_item_type(_trial_summoner));
        ms_reg.set_total_mining_sec(_summoner, ms_trial.total_mining_sec(_trial_summoner));
        ms_reg.set_total_farming_sec(_summoner, ms_trial.total_farming_sec(_trial_summoner));
        ms_reg.set_total_crafting_sec(_summoner, ms_trial.total_crafting_sec(_trial_summoner));
        ms_reg.set_last_total_mining_sec(_summoner, ms_trial.last_total_mining_sec(_trial_summoner));
        ms_reg.set_last_total_farming_sec(_summoner, ms_trial.last_total_farming_sec(_trial_summoner));
        ms_reg.set_last_total_crafting_sec(_summoner, ms_trial.last_total_crafting_sec(_trial_summoner));
        ms_reg.set_last_grooming_time_plus_working_time(_summoner, ms_trial.last_grooming_time_plus_working_time(_trial_summoner));
        ms_reg.set_isActive(_summoner, ms_trial.isActive(_trial_summoner));
        ms_reg.set_inHouse(_summoner, ms_trial.inHouse(_trial_summoner));
        //reset staking counter
        Murasaki_Parameter mp_reg = Murasaki_Parameter(ma_reg.address_Murasaki_Parameter());
        ms_reg.set_staking_reward_counter(_summoner, mp_reg.STAKING_REWARD_SEC());
        /*  =0 when trial
        ms_reg.set_staking_reward_counter(_summoner, ms_trial.staking_reward_counter(_trial_summoner));
        ms_reg.set_total_staking_reward_counter(_summoner, ms_trial.total_staking_reward_counter(_trial_summoner));
        ms_reg.set_last_counter_update_time(_summoner, ms_trial.last_counter_update_time(_trial_summoner));
        ms_reg.set_crafting_resume_flag(_summoner, ms_trial.crafting_resume_flag(_trial_summoner));
        ms_reg.set_crafting_resume_item_type(_summoner, ms_trial.crafting_resume_item_type(_trial_summoner));
        ms_reg.set_crafting_resume_item_dc(_summoner, ms_trial.crafting_resume_item_dc(_trial_summoner));
        ms_reg.set_exp_clarinet(_summoner, ms_trial.exp_clarinet(_trial_summoner));
        ms_reg.set_exp_piano(_summoner, ms_trial.exp_piano(_trial_summoner));
        ms_reg.set_exp_violin(_summoner, ms_trial.exp_violin(_trial_summoner));
        ms_reg.set_exp_horn(_summoner, ms_trial.exp_horn(_trial_summoner));
        ms_reg.set_exp_timpani(_summoner, ms_trial.exp_timpani(_trial_summoner));
        ms_reg.set_exp_cello(_summoner, ms_trial.exp_cello(_trial_summoner));
        ms_reg.set_practice_status(_summoner, ms_trial.practice_status(_trial_summoner));
        ms_reg.set_practice_item_id(_summoner, ms_trial.practice_item_id(_trial_summoner));
        ms_reg.set_practice_start_time(_summoner, ms_trial.practice_start_time(_trial_summoner));
        */
    }
    function _convert_mss (uint _trial_summoner, uint _summoner) internal {
        Murasaki_Address ma_trial = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Address ma_reg = Murasaki_Address(ma_trial.address_Murasaki_Address_Regular());
        Murasaki_Storage_Score mss_trial = Murasaki_Storage_Score(ma_trial.address_Murasaki_Storage_Score());
        Murasaki_Storage_Score mss_reg = Murasaki_Storage_Score(ma_reg.address_Murasaki_Storage_Score());
        mss_reg.set_total_exp_gained(_summoner, mss_trial.total_exp_gained(_trial_summoner));
        mss_reg.set_total_coin_mined(_summoner, mss_trial.total_coin_mined(_trial_summoner));
        mss_reg.set_total_material_farmed(_summoner, mss_trial.total_material_farmed(_trial_summoner));
        mss_reg.set_total_item_crafted(_summoner, mss_trial.total_item_crafted(_trial_summoner));
        mss_reg.set_total_precious_received(_summoner, mss_trial.total_precious_received(_trial_summoner));
        mss_reg.set_total_feeding_count(_summoner, mss_trial.total_feeding_count(_trial_summoner));
        mss_reg.set_total_grooming_count(_summoner, mss_trial.total_grooming_count(_trial_summoner));
        mss_reg.set_total_neglect_count(_summoner, mss_trial.total_neglect_count(_trial_summoner));
        mss_reg.set_total_critical_count(_summoner, mss_trial.total_critical_count(_trial_summoner));
        //increment global count when minting in main gameplay
        mss_reg.increment_global_total_feeding_count(mss_trial.total_feeding_count(_trial_summoner));
        mss_reg.increment_global_total_grooming_count(mss_trial.total_grooming_count(_trial_summoner));
        mss_reg.increment_global_total_coin_mined(mss_trial.total_coin_mined(_trial_summoner));
        mss_reg.increment_global_total_material_farmed(mss_trial.total_material_farmed(_trial_summoner));
        mss_reg.increment_global_total_item_crafted(mss_trial.total_item_crafted(_trial_summoner));
        mss_reg.increment_global_total_precious_received(mss_trial.total_precious_received(_trial_summoner));
    }
    function _mint_and_convert_mc (address _wallet) internal {
        Murasaki_Address ma_trial = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Craft mc_trial = Murasaki_Craft(ma_trial.address_Murasaki_Craft());
        //get all item ids
        uint _myListsLength = mc_trial.myListLength(_wallet);
        uint[] memory _myListsAt = mc_trial.myListsAt(_wallet, 0, _myListsLength);
        //mint and convert each item
        for (uint i=0; i<_myListsLength; i++) {
            uint _trial_item_id = _myListsAt[i];
            //mint and convert
            _craft_regular_item_and_convert(_trial_item_id, _wallet);
            //burn trial_item
            mc_trial.burn(_trial_item_id);
        }
    }
    function _craft_regular_item_and_convert (uint _trial_item_id, address _wallet) internal {
        Murasaki_Address ma_trial = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Address ma_reg = Murasaki_Address(ma_trial.address_Murasaki_Address_Regular());
        Murasaki_Craft mc_trial = Murasaki_Craft(ma_trial.address_Murasaki_Craft());
        Murasaki_Craft mc_reg = Murasaki_Craft(ma_reg.address_Murasaki_Craft());
        //uint _item_id = mc_reg.next_item();
        (
            uint _item_type, 
            , //uint _crafted_time, 
            uint _crafted_summoner, 
            , //address _crafted_wallet, 
            , //string memory _memo,
            uint _item_subtype
        ) = mc_trial.items(_trial_item_id);
        uint _seed = mc_trial.seed(_trial_item_id);
        string memory _memo = "converted from trial";
        mc_reg.craft(
            _item_type, 
            _crafted_summoner, 
            _wallet, 
            _seed, 
            _memo, 
            _item_subtype
        );
    }
    function _burn_trial_summoner (uint _trial_summoner) internal {
        Murasaki_Address ma_trial = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Main mm_trial = Murasaki_Main(ma_trial.address_Murasaki_Main());
        mm_trial.burn(_trial_summoner);
    }
    function _mint_presentbox (uint _summoner, address _wallet_to) internal {
        Murasaki_Address ma_trial = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Address ma_reg = Murasaki_Address(ma_trial.address_Murasaki_Address_Regular());
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma_reg.address_Murasaki_Function_Share());
        Murasaki_Craft mc = Murasaki_Craft(ma_reg.address_Murasaki_Craft());
        uint _seed = mfs.seed(_summoner);
        uint _item_type = 200;
        string memory _memo = "start bonus";
        mc.craft(_item_type, 0, _wallet_to, _seed, _memo, 0);
    }
    function _fee_transfer () internal {
        Murasaki_Address ma_trial = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Address ma_reg = Murasaki_Address(ma_trial.address_Murasaki_Address_Regular());
        Murasaki_Parameter mp_reg = Murasaki_Parameter(ma_reg.address_Murasaki_Parameter());
        payable(ma_reg.address_Coder_Wallet()).transfer(mp_reg.PRICE()/20);          //5%
        payable(ma_reg.address_Illustrator_Wallet()).transfer(mp_reg.PRICE()/20);    //5%
        payable(ma_reg.address_Staking_Wallet()).transfer(address(this).balance/2);  //45%
        payable(ma_reg.address_BuybackTreasury()).transfer(address(this).balance);   //45%
    }
}



//===Add-on==================================================================================================================


//---Murasaki_Market_Item

// @dev of HoM: Following codes are based on "SummonerMarket" contract 
// @dev of HoM: from Rarity game by Andre Cronje on the Fantom chain.
// @dev of HoM: Contract address on the Fantom: 0xee973c3bb8bc27a76bcdf91e6e0921cf78d8e1ff

/// @dev Summoner market to allow trading of summoners
/// @author swit.eth (@nomorebear) + nipun (@nipun_pit) + jade (@jade_arin)

contract Murasaki_Market_Item is Ownable, ReentrancyGuard, ERC721Holder, Pausable {

    //pausable
    function pause() external onlyOwner {
        _pause();
    }
    function unpause() external onlyOwner {
        _unpause();
    }

    //address
    address public address_Murasaki_Address;
    function _set_Murasaki_Address(address _address) external onlyOwner {
        address_Murasaki_Address = _address;
    }

    using EnumerableSet for EnumerableSet.UintSet;

    event List(uint indexed _summoner, uint _item, uint _price);
    event Unlist(uint indexed _summoner, uint _item);
    event Buy(uint indexed _summoner, uint _summonerSeller, uint _item, uint _price, uint _fee);
    event SetFeeBps(uint feeBps);

    //IERC721 public rarity;
    uint public feeBps = 500;
    uint public lowestPrice = 1 * 10**18;   // 1 $ASTR
    uint public dutchAuction_interval = 24 * 60 * 60;   //24 hr
    uint public dutchAuction_startPrice = 500 * 10**18;   //100 $ASTR
    EnumerableSet.UintSet private set;
    mapping(address => EnumerableSet.UintSet) private mySet;
    uint public total_tradingVolume = 0;
    uint public total_tradingCount = 0;

    //mapping
    mapping(uint => uint) public prices;
    mapping(uint => address) public listers;
    mapping(uint => uint) public listedTime;
    mapping(uint => uint) public averageSoldPrice;  //per item_type
    mapping(uint => uint) public soldCount;         //per item_type
    
    // set lowestPrice
    function setLowestPrice(uint _value) external onlyOwner {
        lowestPrice = _value;
    }
    // set total_tradingVolume manually
    function set_total_tradingVolume(uint _value) external onlyOwner {
        total_tradingVolume = _value;
    }

    /// @dev Updates fee. Only callable by owner.
    function setFeeBps(uint _feeBps) external onlyOwner {
        feeBps = _feeBps;
        emit SetFeeBps(_feeBps);
    }
    
    //admin set variants
    function set_dutchAuction_interval (uint _value) external onlyOwner {
        dutchAuction_interval = _value;
    }
    function set_dutchAuction_startPrice (uint _value) external onlyOwner {
        dutchAuction_startPrice = _value;
    }

    /// @dev Lists the given summoner. This contract will take custody until bought / unlisted.
    function list(uint _item, uint price) external nonReentrant whenNotPaused {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Craft mc = Murasaki_Craft(ma.address_Murasaki_Craft());
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        _check_wallet(msg.sender);
        require(price > 0, 'bad price');
        require(prices[_item] == 0, 'already listed');
        require(price >= lowestPrice, 'under the lowest price');
        require(price >= _get_buybackPrice(_item));  //buyback price check
        //rarity.safeTransferFrom(msg.sender, address(this), summonerId);
        mc.safeTransferFrom(msg.sender, address(this), _item);
        prices[_item] = price;
        listers[_item] = msg.sender;
        listedTime[_item] = block.timestamp;
        set.add(_item);
        mySet[msg.sender].add(_item);
        //emit List(_item, msg.sender, price);
        emit List(mfs.get_summoner(msg.sender), _item, price);
    }
    function _get_buybackPrice (uint _item) internal view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        BuybackTreasury bbt = BuybackTreasury(payable(ma.address_BuybackTreasury()));
        return bbt.calc_buybackPrice(_item);
    }

    /// @dev Unlists the given summoner. Must be the lister.
    function unlist(uint _item) external nonReentrant whenNotPaused {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Craft mc = Murasaki_Craft(ma.address_Murasaki_Craft());
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        _check_wallet(msg.sender);
        require(prices[_item] > 0, 'not listed');
        require(listers[_item] == msg.sender, 'not lister');
        prices[_item] = 0;
        listers[_item] = address(0);
        //rarity.safeTransferFrom(address(this), msg.sender, summonerId);
        mc.safeTransferFrom(address(this), msg.sender, _item);
        set.remove(_item);
        mySet[msg.sender].remove(_item);
        //emit Unlist(_item, msg.sender);
        emit Unlist(mfs.get_summoner(msg.sender), _item);
    }

    /// @dev Buys the given summoner. Must pay the exact correct prirce.
    function buy(uint _item) external payable nonReentrant whenNotPaused {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Craft mc = Murasaki_Craft(ma.address_Murasaki_Craft());
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        _check_wallet(msg.sender);
        require(prices[_item] > 0, 'not listed');
        //uint price = prices[_item];
        uint price = get_auctionPrice(_item);
        require(msg.value >= price, 'bad msg.value');
        uint fee = (price * feeBps) / 10000;
        uint get = price - fee;
        address lister = listers[_item];
        prices[_item] = 0;
        listers[_item] = address(0);
        //rarity.safeTransferFrom(address(this), msg.sender, summonerId);
        mc.safeTransferFrom(address(this), msg.sender, _item);
        payable(lister).transfer(get);
        set.remove(_item);
        mySet[lister].remove(_item);
        //fee transfer
        payable(ma.address_BufferVault()).transfer(address(this).balance);
        //update average price
        (uint _item_type, , , , ,) = mc.items(_item);
        uint _newAverageSoldPrice = 
            ( averageSoldPrice[_item_type] * soldCount[_item_type] + price ) 
            / ( soldCount[_item_type] + 1 );
        averageSoldPrice[_item_type] = _newAverageSoldPrice;
        soldCount[_item_type] += 1;
        //update total_tradingVolume
        total_tradingVolume += price;
        total_tradingCount += 1;
        //emit Buy(_item, lister, msg.sender, price, fee);
        emit Buy(mfs.get_summoner(msg.sender), mfs.get_summoner(lister), _item, price, fee);
    }

    //get auction price
    function get_auctionPrice (uint _item) public view returns (uint) {
        uint _listPrice = prices[_item];
        uint _deltaSec = block.timestamp - listedTime[_item];
        uint _price;
        //after 24 hr, listPrice
        if (_deltaSec >= dutchAuction_interval) {
            _price = _listPrice;
        //when listPrice >= startPrice(=100$ASTR), listPrice
        } else if (_listPrice >= dutchAuction_startPrice) {
            _price = _listPrice;
        //when else, listPrice + extraPrice
        } else {
            _price = _listPrice;
            _price += 
                (dutchAuction_startPrice - _listPrice) 
                * (dutchAuction_interval - _deltaSec) 
                / dutchAuction_interval;
        }
        return _price;
    }
    
    //get itemInfo
    //item_type, item_subtype, crafter, (crafter_name), listedPrice, auctionPrice, auctionRestingTime
    function get_itemInfo (uint _item) external view returns (uint[10] memory, string memory) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Craft mc = Murasaki_Craft(ma.address_Murasaki_Craft());
        Murasaki_Name mn = Murasaki_Name(ma.address_Murasaki_Name());
        (
            uint _item_type, 
            , 
            uint _crafter, 
            , 
            , 
            uint _item_subtype
        ) = mc.items(_item);
        uint _deltaSec = block.timestamp - listedTime[_item];
        uint _auctionRestingTime;
        if (_deltaSec >= dutchAuction_interval) {
            _auctionRestingTime = 0;
        } else {
            _auctionRestingTime = dutchAuction_interval - _deltaSec;
        }
        uint[10] memory _res;
        _res[0] = _item_type;
        _res[1] = _item_subtype;
        _res[2] = _crafter;
        _res[3] = prices[_item];
        _res[4] = get_auctionPrice(_item);
        _res[5] = _auctionRestingTime;
        return (_res, mn.names(_crafter));
    }

    //check wallet
    function _check_wallet(address _wallet) public view returns (bool) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Main mm = Murasaki_Main(ma.address_Murasaki_Main());
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        //check summoner possession
        uint _summoner = mm.tokenOf(_wallet);
        require(_summoner > 0);
        //check summoner activation
        require(ms.isActive(_summoner));
        //check summoner petrification
        require(mfs.not_petrified(_summoner));
        return true;
    }

    /// @dev Withdraw trading fees. Only called by owner.
    /*
    function withdraw(uint amount) external onlyOwner {
        payable(msg.sender).transfer(amount == 0 ? address(this).balance : amount);
    }
    */
    function withdraw(address rec)public onlyOwner{
        payable(rec).transfer(address(this).balance);
    }

    /// @dev Returns list the total number of listed summoners.
    function listLength() external view returns (uint) {
        return set.length();
    }

    /// @dev Returns the ids and the prices of the listed summoners.
    function listsAt(uint start, uint count)
        external
        view
        returns (uint[] memory rIds, uint[] memory rPrices)
    {
        rIds = new uint[](count);
        rPrices = new uint[](count);
        for (uint idx = 0; idx < count; idx++) {
            rIds[idx] = set.at(start + idx);
            rPrices[idx] = prices[rIds[idx]];
        }
    }

    /// @dev Returns list the total number of listed summoners of the given user.
    function myListLength(address user) external view returns (uint) {
        return mySet[user].length();
    }

    /// @dev Returns the ids and the prices of the listed summoners of the given user.
    function myListsAt(
        address user,
        uint start,
        uint count
    ) external view returns (uint[] memory rIds, uint[] memory rPrices) {
        rIds = new uint[](count);
        rPrices = new uint[](count);
        for (uint idx = 0; idx < count; idx++) {
            rIds[idx] = mySet[user].at(start + idx);
            rPrices[idx] = prices[rIds[idx]];
        }
    }
    
    //myListsAt, with current auction price instead of listed price
    function myListsAt_withAuctionPrice(
        address user,
        uint start,
        uint count
    ) external view returns (uint[] memory rIds, uint[] memory rPrices) {
        rIds = new uint[](count);
        rPrices = new uint[](count);
        for (uint idx = 0; idx < count; idx++) {
            rIds[idx] = mySet[user].at(start + idx);
            rPrices[idx] = get_auctionPrice(rIds[idx]);
        }
    }
}



//---Murasaki_Dice

contract Murasaki_Dice is Ownable, ReentrancyGuard, Pausable {

    /*
    #calculation: moving average
        rolled_dices = [a, b, c, d]
        roll:
            req(>=20)
            now_dice = d20
            >24*4: [0,0,0,now]
            >24*3: [d,0,0,now]
            >24*2: [c,d,0,now]
            <=24*2: [b,c,d,now]
        get:
            >24*4: 0
            >24*3: d/4
            >24*2: c+d/4
            >24*1: b+c+d/4
            <=24: a+b+c+d/4
        get_now:
            rolled_dices[3]
    */

    //pausable
    function pause() external onlyOwner {
        _pause();
    }
    function unpause() external onlyOwner {
        _unpause();
    }

    //address
    address public address_Murasaki_Address;
    function _set_Murasaki_Address(address _address) external onlyOwner {
        address_Murasaki_Address = _address;
    }

    //variants
    uint public dice_item_type = 5;
    uint public buffer_sec = 14400;  //4 hr
    mapping(uint => uint[4]) public rolled_dice;
    mapping(uint => uint) public last_dice_roll_time;
    //mapping(uint => uint) public critical_count;
    //mapping(uint => uint) public fumble_count;

    //## item types
    //admin, set dice item_type
    function _set2_dice_item_type(uint _item_type) external onlyOwner {
        dice_item_type = _item_type;
    }

    //admin, set buffer_sec
    function _set3_buffer_sec(uint _sec) external onlyOwner {
        buffer_sec = _sec;
    }
    
    //critical_count, mse:101
    function _set_critical_count (uint _summoner, uint _value) internal {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage_Extra mse = Murasaki_Storage_Extra(ma.address_Murasaki_Storage_Extra());
        mse.set_storage(101, _summoner, _value);
    }
    function _add_critical_count (uint _summoner, uint _value) internal {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage_Extra mse = Murasaki_Storage_Extra(ma.address_Murasaki_Storage_Extra());
        mse.add_storage(101, _summoner, _value);
    }
    function _get_critical_count (uint _summoner) internal view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage_Extra mse = Murasaki_Storage_Extra(ma.address_Murasaki_Storage_Extra());
        return mse.get_storage(101, _summoner);
    }
    function critical_count (uint _summoner) external view returns (uint) {
        return _get_critical_count(_summoner);
    }

    //fumble_count, mse:102
    function _set_fumble_count (uint _summoner, uint _value) internal {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage_Extra mse = Murasaki_Storage_Extra(ma.address_Murasaki_Storage_Extra());
        mse.set_storage(102, _summoner, _value);
    }
    function _add_fumble_count (uint _summoner, uint _value) internal {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage_Extra mse = Murasaki_Storage_Extra(ma.address_Murasaki_Storage_Extra());
        mse.add_storage(102, _summoner, _value);
    }
    function _get_fumble_count (uint _summoner) internal view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage_Extra mse = Murasaki_Storage_Extra(ma.address_Murasaki_Storage_Extra());
        return mse.get_storage(102, _summoner);
    }
    function fumble_count (uint _summoner) external view returns (uint) {
        return _get_fumble_count(_summoner);
    }
    
    //global_critical_count, mse:103
    function _increment_global_critical_count () internal {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage_Extra mse = Murasaki_Storage_Extra(ma.address_Murasaki_Storage_Extra());
        mse.add_storage(103, 0, 1);
    }
    function global_critical_count () external view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage_Extra mse = Murasaki_Storage_Extra(ma.address_Murasaki_Storage_Extra());
        return mse.get_storage(103, 0);
    }

    //global_fumble_count, mse:104
    function _increment_global_fumble_count () internal {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage_Extra mse = Murasaki_Storage_Extra(ma.address_Murasaki_Storage_Extra());
        mse.add_storage(104, 0, 1);
    }
    function global_fumble_count () external view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage_Extra mse = Murasaki_Storage_Extra(ma.address_Murasaki_Storage_Extra());
        return mse.get_storage(104, 0);
    }

    //calc elasped_time
    function calc_elasped_time(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        if (last_dice_roll_time[_summoner] == 0) {
            return 86400 * 10;  //if not rolled yet, return 10 days
        } else {
            uint _now = block.timestamp;
            uint SPEED = mp.SPEED();
            uint _elasped_time = (_now - last_dice_roll_time[_summoner]) * SPEED/100;
            return _elasped_time;
        }
    }

    //dice roll
    event Dice_Roll(uint indexed _summoner, uint _rolled_dice);
    function dice_roll(uint _summoner) external nonReentrant whenNotPaused {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        require(mp.isPaused() == false);
        require(mfs.check_owner(_summoner, msg.sender));
        //check dice possession
        address _owner = mfs.get_owner(_summoner);
        require(
            mfs.get_balance_of_type_specific(_owner, dice_item_type) > 0
            || mfs.get_balance_of_type_specific(_owner, dice_item_type +64) > 0
            || mfs.get_balance_of_type_specific(_owner, dice_item_type +128) > 0
        );
        //check elasped_time
        uint BASE_SEC = mp.BASE_SEC();
        uint _elasped_time = calc_elasped_time(_summoner);
        require(_elasped_time >= BASE_SEC - buffer_sec);
        //dice roll
        uint _dice_roll = (mfs.d20(_summoner) + 1) * 10;
        if (_dice_roll == 200) {
            //critical_count[_summoner] += 1;
            //_set_critical_count(_summoner, get_critical_count(_summoner)+1);
            _add_critical_count(_summoner, 1);
            _increment_global_critical_count();
        } else if (_dice_roll == 10) {
            //fumble_count[_summoner] += 1;
            //_set_fumble_count(_summoner, get_fumble_count(_summoner)+1);
            _add_fumble_count(_summoner, 1);
            _increment_global_fumble_count();
        }
        //update rolled_dice, after 48hr, input 0 in each 24hr
        if (_elasped_time > BASE_SEC * 4) {
            rolled_dice[_summoner] = [
                0, 
                0, 
                0, 
                _dice_roll
            ];
        } else if (_elasped_time > BASE_SEC * 3) {
            rolled_dice[_summoner] = [
                rolled_dice[_summoner][3], 
                0, 
                0, 
                _dice_roll
            ];
        } else if (_elasped_time > BASE_SEC * 2) {
            rolled_dice[_summoner] = [
                rolled_dice[_summoner][2], 
                rolled_dice[_summoner][3], 
                0, 
                _dice_roll
            ];
        } else {
            rolled_dice[_summoner] = [
                rolled_dice[_summoner][1], 
                rolled_dice[_summoner][2], 
                rolled_dice[_summoner][3], 
                _dice_roll
            ];
        }
        //update last time
        uint _now = block.timestamp;
        last_dice_roll_time[_summoner] = _now;
        //event
        emit Dice_Roll(_summoner, _dice_roll);
    }
    
    //get rolled dice, average of 4 dices
    function get_rolled_dice(uint _summoner) external view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        //get elasped_time
        uint BASE_SEC = mp.BASE_SEC();
        uint _elasped_time = calc_elasped_time(_summoner);
        //get owner of summoner
        address _owner = mfs.get_owner(_summoner);
        //calc mod_dice
        uint _mod_dice;
        //ignore when not possessed item_dice
        if (
            mfs.get_balance_of_type_specific(_owner, dice_item_type) == 0
            && mfs.get_balance_of_type_specific(_owner, dice_item_type +64) == 0
            && mfs.get_balance_of_type_specific(_owner, dice_item_type +128) == 0
        ) {
            _mod_dice = 0;
        //calc mod_dice depends on delta_sec
        // average of 3
        } else if (_elasped_time > BASE_SEC * 3) {
            _mod_dice = 0;
        } else if (_elasped_time > BASE_SEC * 2) {
            _mod_dice = (
                0 +
                0 +
                rolled_dice[_summoner][3]
                ) / 3;
        } else if (_elasped_time > BASE_SEC * 1) {
            _mod_dice = (
                0 +
                rolled_dice[_summoner][2] +
                rolled_dice[_summoner][3]
                ) / 3;
        } else {
            _mod_dice = (
                rolled_dice[_summoner][1] +
                rolled_dice[_summoner][2] +
                rolled_dice[_summoner][3]
                ) / 3;
        }
        return _mod_dice;
    }
    
    //get last_rolled_dice
    function get_last_rolled_dice(uint _summoner) external view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        address _owner = mfs.get_owner(_summoner);
        uint BASE_SEC = mp.BASE_SEC();
        uint _elasped_time = calc_elasped_time(_summoner);
        if (
            mfs.get_balance_of_type_specific(_owner, dice_item_type) == 0
            && mfs.get_balance_of_type_specific(_owner, dice_item_type +64) == 0
            && mfs.get_balance_of_type_specific(_owner, dice_item_type +128) == 0
        ) {
            return 0;
        } else if (_elasped_time > BASE_SEC * 1) {
            return 0;
        } else {
            return rolled_dice[_summoner][3];
        }
    }
}


//---Murasaki_Mail

contract Murasaki_Mail is Ownable, ReentrancyGuard, Pausable {

    //pausable
    function pause() external onlyOwner {
        _pause();
    }
    function unpause() external onlyOwner {
        _unpause();
    }

    //address
    address public address_Murasaki_Address;
    function _set_Murasaki_Address(address _address) external onlyOwner {
        address_Murasaki_Address = _address;
    }
    
    //mail
    struct Mail {
        uint send_time;
        uint open_time;
        uint summoner_from;
        uint summoner_to;
    }
    mapping(uint => Mail) public mails;

    //mapping
    mapping(uint => uint) public sending;   //[_summoner_from] = mails;
    mapping(uint => uint) public receiving; //[_summoner_to] = mails;
    //mapping(uint => uint) public total_sent;
    //mapping(uint => uint) public total_opened;
    
    //variants
    //interval, both of sending interval & receving limit
    uint public interval_sec = 60 * 60 * 24 * 7;    // 7 days
    //## item types
    uint public item_type_of_mail = 196;
    uint public item_type_of_cushion = 23;
    
    //global
    uint public global_total_mail_sent = 0;
    uint public global_total_mail_opened = 0;

    //admin, set variants
    function set_interval_sec(uint _value) external onlyOwner {
        interval_sec = _value;
    }
    function set_item_type_of_mail(uint _value) external onlyOwner {
        item_type_of_mail = _value;
    }
    function set_item_type_of_cushion(uint _value) external onlyOwner {
        item_type_of_cushion = _value;
    }

    //total_sent, mse:201
    function _set_total_sent (uint _summoner, uint _value) internal {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage_Extra mse = Murasaki_Storage_Extra(ma.address_Murasaki_Storage_Extra());
        mse.set_storage(201, _summoner, _value);
    }
    function _add_total_sent (uint _summoner, uint _value) internal {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage_Extra mse = Murasaki_Storage_Extra(ma.address_Murasaki_Storage_Extra());
        mse.add_storage(201, _summoner, _value);
    }
    function _get_total_sent (uint _summoner) internal view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage_Extra mse = Murasaki_Storage_Extra(ma.address_Murasaki_Storage_Extra());
        return mse.get_storage(201, _summoner);
    }
    function total_sent (uint _summoner) external view returns (uint) {
        return _get_total_sent(_summoner);
    }

    //total_opened, mse:202
    function _set_total_opened (uint _summoner, uint _value) internal {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage_Extra mse = Murasaki_Storage_Extra(ma.address_Murasaki_Storage_Extra());
        mse.set_storage(202, _summoner, _value);
    }
    function _add_total_opened (uint _summoner, uint _value) internal {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage_Extra mse = Murasaki_Storage_Extra(ma.address_Murasaki_Storage_Extra());
        mse.add_storage(202, _summoner, _value);
    }
    function _get_total_opened (uint _summoner) internal view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage_Extra mse = Murasaki_Storage_Extra(ma.address_Murasaki_Storage_Extra());
        return mse.get_storage(202, _summoner);
    }
    function total_opened (uint _summoner) external view returns (uint) {
        return _get_total_opened(_summoner);
    }
    
    //global_total_sent, mse:203
    function _increment_global_total_sent() internal {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage_Extra mse = Murasaki_Storage_Extra(ma.address_Murasaki_Storage_Extra());
        mse.add_storage(203, 0, 1);
    }
    function global_total_sent () external view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage_Extra mse = Murasaki_Storage_Extra(ma.address_Murasaki_Storage_Extra());
        return mse.get_storage(203, 0);
    }
    
    //global_total_opened, mse:204
    function _increment_global_total_opened() internal {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage_Extra mse = Murasaki_Storage_Extra(ma.address_Murasaki_Storage_Extra());
        mse.add_storage(204, 0, 1);
    }
    function global_total_opened () external view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage_Extra mse = Murasaki_Storage_Extra(ma.address_Murasaki_Storage_Extra());
        return mse.get_storage(204, 0);
    }
        
    //check mail
    function check_receiving_mail(uint _summoner_to) public view returns (bool) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        uint SPEED = mp.SPEED();
        uint _mail_id = receiving[_summoner_to];
        //no mail
        if (_mail_id == 0) {
            return false;
        } else {
            Mail memory _mail = mails[_mail_id];
            uint _now = block.timestamp;
            uint _delta = (_now - _mail.send_time) * SPEED/100;
            //expired
            if (_delta >= interval_sec) {
                return false;
            // already opend
            } else if (_mail.open_time != 0) {
                return false;
            } else {
                return true;
            }
        }
    }
    
    //calc sending interval
    function calc_sending_interval(uint _summoner_from) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        uint SPEED = mp.SPEED();
        uint _mail_id = sending[_summoner_from];
        //not send yet
        if (_mail_id == 0) {
            return 0;
        }
        //mail sending
        Mail memory _mail = mails[_mail_id];
        uint _now = block.timestamp;
        uint _delta = (_now - _mail.send_time) * SPEED/100;
        if (_delta >= interval_sec) {
            return 0;
        } else {
            return interval_sec - _delta;
        }
    }
    
    //check last mail open
    function check_lastMailOpen(uint _summoner_from) public view returns (bool) {
        uint _mail_id = sending[_summoner_from];
        if (_mail_id == 0) {
            return false;
        }
        Mail memory _mail = mails[_mail_id];
        if (_mail.open_time > 0) {
            return true;
        } else {
            return false;
        }
    }
    
    //send mail, need to burn item_mail nft
    event Send_Mail(uint indexed _summoner_from, uint _summoner_to, uint _item_mail);
    function send_mail(uint _summoner_from, uint _item_mail) external nonReentrant whenNotPaused {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        Murasaki_Craft mc = Murasaki_Craft(ma.address_Murasaki_Craft());
        require(mp.isPaused() == false);
        //check owner
        require(mfs.check_owner(_summoner_from, msg.sender));
        //check cushion in wallet
        address _owner = mfs.get_owner(_summoner_from);
        require(
            mfs.get_balance_of_type_specific(_owner, item_type_of_cushion) > 0
            || mfs.get_balance_of_type_specific(_owner, item_type_of_cushion+64) > 0
            || mfs.get_balance_of_type_specific(_owner, item_type_of_cushion+128) > 0
            );
        //check sending interval
        require(calc_sending_interval(_summoner_from) == 0);
        //check _item_mail nft
        (uint _item_type, , , , ,) = mc.items(_item_mail);
        require(_item_type == item_type_of_mail);
        require(mc.ownerOf(_item_mail) == msg.sender);
        //burn mail nft
        _burn_mail(_item_mail);
        //select _summoner_to
        uint _summoner_to = _select_random_summoner_to(_summoner_from);
        //prepare Mail, id = _item_mail
        uint _now = block.timestamp;
        Mail memory _mail = Mail(_now, 0, _summoner_from, _summoner_to);
        mails[_item_mail] = _mail;
        //send mail
        sending[_summoner_from] = _item_mail;
        receiving[_summoner_to] = _item_mail;
        //total_sent[_summoner_from] += 1;
        //_set_total_sent(_summoner_from, get_total_sent(_summoner) + 1);
        _add_total_sent(_summoner_from, 1);
        _increment_global_total_sent();
        //event
        emit Send_Mail(_summoner_from, _summoner_to, _item_mail);
    }
    function _select_random_summoner_to(uint _summoner_from) internal view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Main mm = Murasaki_Main(ma.address_Murasaki_Main());
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        uint _count_summoners = mm.next_token() - 1;
        uint _summoner_to = 0;
        uint _count = 0;
        while (_count < 5) {
            uint _summoner_tmp = mfs.dn(_summoner_from + _count, _count_summoners) + 1;
            if (
                _summoner_to == 0
                && ms.isActive(_summoner_tmp)
                //&& ms.level(_summoner_tmp) >= 3
                && mfs.calc_satiety(_summoner_tmp) >= 30
                && mfs.calc_happy(_summoner_tmp) >= 30
                && _summoner_tmp != _summoner_from
            ) {
                _summoner_to = _summoner_tmp;
            }
            _count += 1;
            /*
            bool _isActive = ms.isActive(_summoner_tmp);
            uint _happy = mfs.calc_happy(_summoner_tmp);
            if (
                _summoner_to == 0
                && _isActive == true
                && _happy >= 10
                && check_receiving_mail(_summoner_tmp) == false
                && _summoner_tmp != _summoner_from
            ) {
                _summoner_to = _summoner_tmp;
            }
            _count += 1;
            */
        }
        return _summoner_to;
    }
    function _burn_mail(uint _item_mail) internal {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Crafting mfc = Murasaki_Function_Crafting(ma.address_Murasaki_Function_Crafting());
        mfc.burn_mail(_item_mail);
    }
    
    //open mail
    event Open_Mail(uint indexed _summoner_to, uint _summoner_from);
    function open_mail(uint _summoner_to) external nonReentrant whenNotPaused {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        require(mp.isPaused() == false);
        //check owner
        require(mfs.check_owner(_summoner_to, msg.sender));
        //check receving mail
        require(check_receiving_mail(_summoner_to));
        //get mail
        uint _mail_id = receiving[_summoner_to];
        Mail storage _mail = mails[_mail_id];
        receiving[_summoner_to] = 0;
        //open mail
        uint _now = block.timestamp;
        _mail.open_time = _now;
        //mint precious
        //_mint_precious(_summoner_to, _mail.summoner_from);
        _mint_presentboxBoth(_summoner_to, _mail.summoner_from);
        //total_opened[_summoner_to] += 1;
        _add_total_opened(_summoner_to, 1);
        _increment_global_total_opened();
        //event
        emit Open_Mail(_summoner_to, _mail.summoner_from);
    }
    function _mint_presentboxBoth(uint _summoner_to, uint _summoner_from) internal {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Main mm = Murasaki_Main(ma.address_Murasaki_Main());
        _mint_presentbox(_summoner_from, mm.ownerOf(_summoner_to));
        _mint_presentbox(_summoner_to, mm.ownerOf(_summoner_from));
    }
    function _mint_presentbox(uint _summoner_from, address _wallet_to) internal {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Craft mc = Murasaki_Craft(ma.address_Murasaki_Craft());
        uint _seed = mfs.seed(_summoner_from);
        uint _item_type = 200;
        string memory _memo = "mail opening";
        mc.craft(_item_type, _summoner_from, _wallet_to, _seed, _memo, 0);
    }    
}


//---Fluffy_Festival

contract Fluffy_Festival is Ownable, ReentrancyGuard, Pausable {

    //pausable
    function pause() external onlyOwner {
        _pause();
    }
    function unpause() external onlyOwner {
        _unpause();
    }

    //address
    address public address_Murasaki_Address;
    function _set_Murasaki_Address(address _address) external onlyOwner {
        address_Murasaki_Address = _address;
    }

    //admin withdraw all
    function withdraw(address rec)public onlyOwner{
        payable(rec).transfer(address(this).balance);
    }
    
    //global variants
    uint public ELECTION_PERIOD_BLOCK = 7200; //1 days, 12sec/block
    uint public LEVEL_REQUIRED = 1;
    uint public SATIETY_REQUIRED = 10;
    uint public HAPPY_REQUIRED = 10;
    uint public ELECTION_INTERVAL_BLOCK = 216000; //30 days, 12sec/block
    uint public FESTIVAL_STARTABLE_BLOCK = 0;    //for contract replacement
    bool public inSession;
    bool public isActive = true;
    uint public elected_type = 0;
    uint public previous_elected_type = 0;
    
    //admin, change global variants
    function _setA_election_period_block(uint  _value) external onlyOwner {
        ELECTION_PERIOD_BLOCK = _value;
    }
    function _setB_level_required(uint  _value) external onlyOwner {
        LEVEL_REQUIRED = _value;
    }
    function _setC_satiety_required(uint  _value) external onlyOwner {
        SATIETY_REQUIRED = _value;
    }
    function _setD_happy_required(uint  _value) external onlyOwner {
        HAPPY_REQUIRED = _value;
    }
    function _setE_election_interval_block(uint  _value) external onlyOwner {
        ELECTION_INTERVAL_BLOCK = _value;
    }
    function _setF_inSession(bool _bool) external onlyOwner {
        inSession = _bool;
    }
    function _setG_isActive(bool _bool) external onlyOwner {
        isActive = _bool;
    }
    function _setH_FESTIVAL_STARTABLE_BLOCK(uint _value) external onlyOwner {
        FESTIVAL_STARTABLE_BLOCK = _value;
    }
    function _setI_elected_type(uint _value) external onlyOwner {
        elected_type = _value;
    }
    function _setJ_previous_elected_type(uint _value) external onlyOwner {
        previous_elected_type = _value;
    }
    
    //admin, modify subject parameters for maintenance
    function _modify_subject(
        uint _subject_no,
        uint _start_block,
        uint _end_block,
        uint _start_step,
        uint _end_step,
        uint _elected_type
    ) external onlyOwner {
        subjects[_subject_no] = Subject(
            _start_block, 
            _end_block, 
            _start_step, 
            _end_step,
            _elected_type
        );
    }

    //subject
    uint subject_now = 0;
    struct Subject {
        uint start_block;
        uint end_block;
        uint start_step;
        uint end_step;
        uint elected_type;
    }
    mapping(uint => Subject) public subjects;
    
    //vote
    uint next_vote = 1;
    struct vote {
        uint blocknumber;
        uint summoner;
        uint value;
        uint power;
    }
    mapping(uint => vote) public votes;
    uint[320] each_voting_count;
    mapping(uint => uint) public last_voting_block; //summoner => blocknumber
    mapping(uint => uint) public last_voting_type;  //summoner => fluffy_type
    //mapping(uint => uint) public voteCount;


    //Storage Extra
    
    //voteCount, mse:401
    function _set_voteCount (uint _summoner, uint _value) internal {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage_Extra mse = Murasaki_Storage_Extra(ma.address_Murasaki_Storage_Extra());
        mse.set_storage(401, _summoner, _value);
    }
    function _add_voteCount (uint _summoner, uint _value) internal {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage_Extra mse = Murasaki_Storage_Extra(ma.address_Murasaki_Storage_Extra());
        mse.add_storage(401, _summoner, _value);
    }
    function _get_voteCount (uint _summoner) internal view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage_Extra mse = Murasaki_Storage_Extra(ma.address_Murasaki_Storage_Extra());
        return mse.get_storage(401, _summoner);
    }
    function voteCount (uint _summoner) external view returns (uint) {
        return _get_voteCount(_summoner);
    }
    
    //global_vote_count, mse:402
    function _increment_global_voteCount () internal {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage_Extra mse = Murasaki_Storage_Extra(ma.address_Murasaki_Storage_Extra());
        mse.add_storage(402, 0, 1);
    }
    function global_voteCount () external view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage_Extra mse = Murasaki_Storage_Extra(ma.address_Murasaki_Storage_Extra());
        return mse.get_storage(402, 0);
    }
    
    //step
    uint next_step = 1;
    mapping(uint => uint) public winner_inStep;

    //Voting
    event Start_Voting(uint indexed _summoner);
    event Voting(uint indexed _summoner, uint _select);
    function voting (uint _summoner, uint _select) external nonReentrant whenNotPaused {
        //check ff active
        require(isActive);
        //check owner
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        require(mfs.check_owner(_summoner, msg.sender));
        //check summoner
        require(_check_summoner(_summoner));
        //reject present and previous elected type
        require(_select != elected_type);
        require(_select != previous_elected_type);
        require(_select >= 201 && _select <= 212);
        //check first voting
        if ( check_start_voting() ){
            emit Start_Voting(_summoner);
            _start_voting(msg.sender);
        }
        //check votable of summoner
        require(check_votable(_summoner));
        // get voting power
        uint _power = _get_votingPower(_summoner);
        //vote
        uint _block = block.number;
        votes[next_vote] = vote(_block, _summoner, _select, _power);
        last_voting_block[_summoner] = _block;
        last_voting_type[_summoner] = _select;
        //each_voting_count[_select] += 1;
        each_voting_count[_select] += _power;
        //voteCount[_summoner] += 1;
        _add_voteCount(_summoner, 1);
        next_vote += 1;
        //update winner in step
        winner_inStep[next_step] = _get_winner_inStep_now();
        next_step += 1;
        //mint presentbox
        string memory _memo = "participation award";
        _mint_presentbox(uint(0), msg.sender, _memo);
        //check final voting
        if ( check_end_voting() ) {
            _end_voting(_summoner, msg.sender);
        }
        emit Voting(_summoner, _select);
    }
    function check_votable(uint _summoner) public view returns (bool) {
        //get subject_now
        Subject memory _subject = subjects[subject_now];
        if (
            //can star voting
            check_start_voting()
            //or after start, meet the all condition
            || (
                //check in session
                inSession
                //check not have already voted
                && _subject.start_block > last_voting_block[_summoner]
            )
        ){
            return true;
        } else {
            return false;
        }
    }
    function _get_votingPower (uint _summoner) internal view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        address _owner = mfs.get_owner(_summoner);
        uint _staker = mfs.calc_dapps_staking_amount(_owner);
        uint _power = 100;
        if (_staker < 500) {
            _power += 0;
        } else if (_staker < 1000) {
            _power += 1;
        } else if (_staker < 2000) {
            _power += 1;
        } else if (_staker < 3000) {
            _power += 2;
        } else if (_staker < 4000) {
            _power += 4;
        } else if (_staker < 5000) {
            _power += 8;
        } else if (_staker < 6000) {
            _power += 14;
        } else if (_staker < 7000) {
            _power += 22;
        } else if (_staker < 8000) {
            _power += 32;
        } else if (_staker < 9000) {
            _power += 44;
        } else if (_staker < 10000) {
            _power += 60;
        } else if (_staker < 20000) {
            _power += 80;
        } else if (_staker < 30000) {
            _power += 85;
        } else if (_staker < 40000) {
            _power += 90;
        } else if (_staker < 50000) {
            _power += 94;
        } else if (_staker < 75000) {
            _power += 97;
        } else if (_staker < 100000) {
            _power += 99;
        } else if (_staker >= 100000) {
            _power += 100;
        }        
        return _power;
    }
    function _check_summoner (uint _summoner) internal view returns (bool) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        if (
            //check pause
            mp.isPaused() == false
            //check owner
            //&& mfs.check_owner(_summoner, _wallet)
            //check summoner status
            && ms.inHouse(_summoner)
            && mfs.calc_satiety(_summoner) >= SATIETY_REQUIRED
            && mfs.calc_happy(_summoner) >= HAPPY_REQUIRED
            && ms.level(_summoner) >= LEVEL_REQUIRED
        ){
            return true;
        } else {
            return false;
        }
    }
    function _get_winner_inStep_now() internal view returns (uint) {
        //return fluffy type with the biggest voting count
        //when equal, smaller type number win
        uint _winner = 0;
        uint _voted = 0;
        for (uint i=201; i<=212; i++) {
            if (each_voting_count[i] > _voted) {
                _winner = i;
                _voted = each_voting_count[i];
            }
        }
        return _winner;
    }
    function _mint_presentbox(uint _summoner, address _wallet_to, string memory _memo) internal {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Craft mc = Murasaki_Craft(ma.address_Murasaki_Craft());
        uint _seed = mfs.seed(_summoner);
        uint _item_type = 200;
        mc.craft(_item_type, _summoner, _wallet_to, _seed, _memo, 0);
    }
    
    //start voting
    function check_start_voting() public view returns (bool) {
        //check blocknumber
        Subject memory _subject = subjects[subject_now];
        if (
            block.number >= _subject.start_block + ELECTION_INTERVAL_BLOCK
            && block.number >= FESTIVAL_STARTABLE_BLOCK

        ) {
            return true;
        } else {
            return false;
        }
    }
    function _start_voting(address _starter) internal {
        //create and initialize subject
        uint _block = block.number;
        subject_now += 1;
        subjects[subject_now] = Subject(
            _block, 
            _block + ELECTION_PERIOD_BLOCK, 
            next_step, 
            0,
            0
        );
        //reset voting count
        for (uint i=201; i<=212; i++) {
            each_voting_count[i] = 0;
        }
        //voting in session
        inSession = true;
        //bonus mint
        string memory _memo = "first vote bonus";
        _mint_presentbox(uint(0), _starter, _memo);
        //emit Start_Voting(_summoner);
    }
    
    //end voting
    function check_end_voting() public view returns (bool) {
        //check blocknumber
        if (
            block.number >= subjects[subject_now].end_block 
            && inSession 
        ) {
            return true;
        } else {
            return false;
        }
    }
    //public, executable without voting
    event End_Voting(uint indexed _summoner, uint _winner);
    function end_voting(uint _summoner) external nonReentrant whenNotPaused {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        require(mfs.check_owner(_summoner, msg.sender));
        require(_check_summoner(_summoner));
        require(check_end_voting());
        _end_voting(_summoner, msg.sender);
    }
    function _end_voting(uint _summoner, address _ender) internal {
        //update session status
        inSession = false;
        //select winner
        uint _winner = _select_winner(_summoner);
        //update mp parameter
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        mp._set_elected_fluffy_type(_winner);
        //insert end step into last subject
        subjects[subject_now].end_step = next_step - 1;
        //update elected type
        subjects[subject_now].elected_type = _winner;
        previous_elected_type = elected_type;
        elected_type = _winner;
        //vonus mint
        string memory _memo = "final vote bonus";
        //_mint_presentbox(uint(0), msg.sender, _memo);
        _mint_presentbox(uint(0), _ender, _memo);
        emit End_Voting(_summoner, _winner);
    }
    function _select_winner(uint _summoner) internal view returns (uint) {
        //candle auction
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        //select random step in the range between from start_step to latest step
        Subject memory _subject = subjects[subject_now];
        uint _delta_step = (next_step) - _subject.start_step;
        uint _rand = mfs.dn(_summoner, _delta_step);
        uint _elected_step = _subject.start_step + _rand;
        //return winner as winner_inStep of the elected_step
        return winner_inStep[_elected_step];
    }
    
    //info
    function get_info(uint _summoner) external view returns (uint[24] memory) {
        uint[24] memory _res;
        //_res[0] = each_voting_count[0];
        _res[1] = each_voting_count[201];
        _res[2] = each_voting_count[202];
        _res[3] = each_voting_count[203];
        _res[4] = each_voting_count[204];
        _res[5] = each_voting_count[205];
        _res[6] = each_voting_count[206];
        _res[7] = each_voting_count[207];
        _res[8] = each_voting_count[208];
        _res[9] = each_voting_count[209];
        _res[10] = each_voting_count[210];
        _res[11] = each_voting_count[211];
        _res[12] = each_voting_count[212];
        _res[13] = next_festival_block();
        _res[14] = _inSession();
        _res[15] = _isVotable(_summoner);
        _res[16] = last_voting_block[_summoner];
        _res[17] = last_voting_type[_summoner];
        _res[18] = subject_now;
        _res[19] = subjects[subject_now].start_block;
        _res[20] = subjects[subject_now].end_block;
        _res[21] = _isEndable();
        _res[22] = elected_type;
        _res[23] = previous_elected_type;
        return _res;
    }
    function _inSession() internal view returns (uint) {
        bool _bool = inSession;
        if (_bool == true) {
            return uint(1);
        } else {
            return uint(0);
        }    
    }
    function _isVotable(uint _summoner) internal view returns (uint) {
        bool _bool = check_votable(_summoner);
        if (_bool == true) {
            return uint(1);
        } else {
            return uint(0);
        }
    }
    function _isEndable() internal view returns (uint) {
        bool _bool = check_end_voting();
        if (_bool == true) {
            return uint(1);
        } else {
            return uint(0);
        }
    }
    function next_festival_block() public view returns (uint) {
        //in first festival, return past block number (0+INTERVAL)
        //for murasaki_info
        uint _next_festival_block;
        if (subjects[subject_now].start_block + ELECTION_INTERVAL_BLOCK <= FESTIVAL_STARTABLE_BLOCK) {
            _next_festival_block = FESTIVAL_STARTABLE_BLOCK;
        } else {
            _next_festival_block = subjects[subject_now].start_block + ELECTION_INTERVAL_BLOCK;
        }
        return _next_festival_block;
    }
}



//---Achievement_onChain

contract Achievement_onChain is Ownable, Pausable {

    //pausable
    function pause() external onlyOwner {
        _pause();
    }
    function unpause() external onlyOwner {
        _unpause();
    }

    //address
    address public address_Murasaki_Address;
    function _set_Murasaki_Address(address _address) external onlyOwner {
        address_Murasaki_Address = _address;
    }
    
    //token/nft address
    mapping(uint => address) public tokens;
    mapping(uint => address) public nfts;
    uint public token_number;
    uint public nft_number;
    
    //astarbase address
    //address public address_AstarBase;
    
    //murasaki nft address
    address public address_Murasaki_NFT;
    address public address_Murasaki_NFT2;
    
    //admin, set address
    //function _set_AstarBase(address _address) external onlyOwner {
    //    address_AstarBase = _address;
   // }
    function _set_Murasaki_NFT(address _address) external onlyOwner {
        address_Murasaki_NFT = _address;
    }
    function _set_Murasaki_NFT2(address _address) external onlyOwner {
        address_Murasaki_NFT2 = _address;
    }
    
    //admin, set token/nft address
    function _set_tokens(uint _number, address _address) external onlyOwner {
        tokens[_number] = _address;
    }
    function _set_nfts(uint _number, address _address) external onlyOwner {
        nfts[_number] = _address;
    }
    
    //admin, set toke/nft number
    function _set_token_number(uint _value) external onlyOwner {
        token_number = _value;
    }
    function _set_nft_number(uint _value) external onlyOwner {
        nft_number = _value;
    }
    
    //## item types
    //admin, set flower_wreath item_type
    uint public flowerWreath_item_type = 35;
    function _set_flowerWreath_item_type (uint _item_type) external onlyOwner {
        flowerWreath_item_type = _item_type;
    }
    
    //get_score
    function get_score (uint _summoner) public view whenNotPaused returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        address _owner = mfs.get_owner(_summoner);
        uint _score_token = get_score_token(_owner);
        uint _score_nft = get_score_nft(_owner);
        uint _score_staking = get_score_staking(_owner);
        uint _score_murasaki_nft = get_score_murasaki_nft(_owner);
        uint _score = _score_token + _score_nft + _score_staking + _score_murasaki_nft;
        //trial limit; score=0
        if (mfs.isTrial()){
            _score=0;
        }
        return _score;
    }
    
    //get_score, item checked
    function get_score_itemChecked (uint _summoner) external view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        address _owner = mfs.get_owner(_summoner);
        uint _score;
        if ( mfs.get_balance_of_type_specific(_owner, flowerWreath_item_type) > 0 ) {
            _score = get_score(_summoner);
        } else {
            _score = 0;
        }
        return _score;
    }
    
    //get_scores as array
    function get_scores (uint _summoner) external view returns (uint[5] memory) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        address _owner = mfs.get_owner(_summoner);
        uint _score_token = get_score_token(_owner);
        uint _score_nft = get_score_nft(_owner);
        uint _score_staking = get_score_staking(_owner);
        uint _score_murasaki_nft = get_score_murasaki_nft(_owner);
        uint _score = _score_token + _score_nft + _score_staking + _score_murasaki_nft;
        uint[5] memory _scores = [
            _score, 
            _score_token, 
            _score_nft, 
            _score_staking, 
            _score_murasaki_nft
        ];
        return _scores;
    }
    
    //internal, calc each score, min:0, max:100, 100=1%
    //0.037
    function get_score_token(address _owner) public view returns (uint) {
        uint _score = 0;
        for (uint i = 1; i <= token_number; i++) {
            ERC20 _token = ERC20(tokens[i]);
            uint _balance = _token.balanceOf(_owner);
            if (_balance > 0) {
                _score += 10;
            }
        }
        if (_score > 100) {
            _score = 100;
        }
        return _score;
    }
    //0.037
    function get_score_nft(address _owner) public view returns (uint) {
        uint _score = 0;
        for (uint i = 1; i <= nft_number; i++) {
            ERC721 _nft = ERC721(nfts[i]);
            uint _balance = _nft.balanceOf(_owner);
            if (_balance > 0) {
                _score += 10;
            }
        }
        if (_score > 100) {
            _score = 100;
        }
        return _score;
    }
    //0.04
    function get_score_staking(address _owner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        uint _staker = mfs.calc_dapps_staking_amount(_owner);
        uint _score;
        /*
        if (_staker == 0) {
            _score = 0;
        } else if (_staker < 500) {
            _score = 10;
        } else if (_staker < 1000) {
            _score = 20;
        } else if (_staker < 2000) {
            _score = 30;
        } else if (_staker < 4000) {
            _score = 40;
        } else if (_staker < 8000) {
            _score = 50;
        } else if (_staker < 16000) {
            _score = 60;
        } else if (_staker < 32000) {
            _score = 70;
        } else if (_staker < 64000) {
            _score = 80;
        } else if (_staker < 128000) {
            _score = 90;
        } else if (_staker >= 128000) {
            _score = 100;
        }
        */
        // 241114, updated
        if (_staker < 500) {
            _score = 0;
        } else if (_staker < 1000) {
            _score = 1;
        } else if (_staker < 2000) {
            _score = 2;
        } else if (_staker < 3000) {
            _score = 4;
        } else if (_staker < 4000) {
            _score = 8;
        } else if (_staker < 5000) {
            _score = 16;
        } else if (_staker < 6000) {
            _score = 28;
        } else if (_staker < 7000) {
            _score = 44;
        } else if (_staker < 8000) {
            _score = 64;
        } else if (_staker < 9000) {
            _score = 88;
        } else if (_staker < 10000) {
            _score = 120;
        } else if (_staker < 20000) {
            _score = 160;
        } else if (_staker < 30000) {
            _score = 170;
        } else if (_staker < 40000) {
            _score = 180;
        } else if (_staker < 50000) {
            _score = 188;
        } else if (_staker < 75000) {
            _score = 194;
        } else if (_staker < 100000) {
            _score = 198;
        } else if (_staker >= 100000) {
            _score = 200;
        }
        return _score;
    }
    //0.025
    function get_score_murasaki_nft(address _owner) public view returns (uint) {
        ERC721 _nft = ERC721(address_Murasaki_NFT);
        ERC721 _nft2 = ERC721(address_Murasaki_NFT2);
        uint _score = _nft.balanceOf(_owner) * 10;
        _score += _nft2.balanceOf(_owner) * 10;
        if (_score > 100) {
            _score = 100;
        }
        return _score;
    }
}


//---Stroll

contract Stroll is Ownable, ReentrancyGuard, Pausable {

    //pausable
    function pause() external onlyOwner {
        _pause();
    }
    function unpause() external onlyOwner {
        _unpause();
    }

    //address
    address public address_Murasaki_Address;
    function _set_Murasaki_Address(address _address) external onlyOwner {
        address_Murasaki_Address = _address;
    }

    //## item types
    //nameplate item_type
    uint public waterBottle_item_type = 41;
    //set dice item_type
    function _set_waterBottle_item_type(uint _item_type) external onlyOwner {
        waterBottle_item_type = _item_type;
    }
    
    //admin
    bool public isActive = true;
    function _set_isActive (bool _bool) external onlyOwner {
        isActive = _bool;
    }
    
    //mapping

    //public summoner accumulated parameters
    //mapping (uint => uint) public total_strolledDistance;
    //mapping (uint => uint) public total_metSummoners;
    //mapping (uint => uint) public stroll_level;
    //mapping (uint => uint) public met_level;
    //mapping (uint => uint[4]) public total_strolledDistance_ofCompanion;

    //public summoner dynamic parameters
    mapping (uint => bool) public isStrolling;
    mapping (uint => uint) public start_time;
    mapping (uint => uint) public end_time;
    mapping (uint => uint[5]) public metSummoners;

    //private summoner parameters
    mapping (uint => uint) private direction;
    mapping (uint => uint) private companion;
    mapping (uint => uint) private drink;
    mapping (uint => mapping(uint => uint)) private summoner2summoner_metTime;

    //global parameters
    using EnumerableSet for EnumerableSet.UintSet;
    mapping (uint => EnumerableSet.UintSet) private strolledSummoners;
    mapping (uint => uint) public total_strolling_direction;
    mapping (uint => uint) public total_strolling_companion;


    //Storage Extra

    //wrapper, Murasaki_Storage_Extra
    function __set_storage (uint _storageId, uint _summoner, uint _value) internal {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage_Extra mse = Murasaki_Storage_Extra(ma.address_Murasaki_Storage_Extra());
        mse.set_storage(_storageId, _summoner, _value);
    }
    function __add_storage (uint _storageId, uint _summoner, uint _value) internal {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage_Extra mse = Murasaki_Storage_Extra(ma.address_Murasaki_Storage_Extra());
        mse.add_storage(_storageId, _summoner, _value);
    }
    function __get_storage (uint _storageId, uint _summoner) internal view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage_Extra mse = Murasaki_Storage_Extra(ma.address_Murasaki_Storage_Extra());
        return mse.get_storage(_storageId, _summoner);
    }

    //total_strolledDistance, mse:301
    function _set_total_strolledDistance (uint _summoner, uint _value) internal {
        __set_storage(301, _summoner, _value);
    }
    function _add_total_strolledDistance (uint _summoner, uint _value) internal {
        __add_storage(301, _summoner, _value);
    }
    function _get_total_strolledDistance (uint _summoner) internal view returns (uint) {
        return __get_storage(301, _summoner);
    }
    function total_strolledDistance (uint _summoner) public view returns (uint) {
        return _get_total_strolledDistance(_summoner);
    }

    //total_metSummoners, mse:302
    function _set_total_metSummoners (uint _summoner, uint _value) internal {
        __set_storage(302, _summoner, _value);
    }
    function _add_total_metSummoners (uint _summoner, uint _value) internal {
        __add_storage(302, _summoner, _value);
    }
    function _get_total_metSummoners (uint _summoner) internal view returns (uint) {
        return __get_storage(302, _summoner);
    }
    function total_metSummoners (uint _summoner) public view returns (uint) {
        return _get_total_metSummoners(_summoner);
    }

    //stroll_level, mse:303
    function _set_stroll_level (uint _summoner, uint _value) internal {
        __set_storage(303, _summoner, _value);
    }
    function _add_stroll_level (uint _summoner, uint _value) internal {
        __add_storage(303, _summoner, _value);
    }
    function _get_stroll_level (uint _summoner) internal view returns (uint) {
        return __get_storage(303, _summoner);
    }
    function stroll_level (uint _summoner) public view returns (uint) {
        return _get_stroll_level(_summoner);
    }

    //met_level, mse:304
    function _set_met_level (uint _summoner, uint _value) internal {
        __set_storage(304, _summoner, _value);
    }
    function _add_met_level (uint _summoner, uint _value) internal {
        __add_storage(304, _summoner, _value);
    }
    function _get_met_level (uint _summoner) internal view returns (uint) {
        return __get_storage(304, _summoner);
    }
    function met_level (uint _summoner) public view returns (uint) {
        return _get_met_level(_summoner);
    }

    //total_strolledDistance_ofCompanion_01, mse:305
    function _set_total_strolledDistance_ofCompanion_01 (uint _summoner, uint _value) internal {
        __set_storage(305, _summoner, _value);
    }
    function _add_total_strolledDistance_ofCompanion_01 (uint _summoner, uint _value) internal {
        __add_storage(305, _summoner, _value);
    }
    function _get_total_strolledDistance_ofCompanion_01 (uint _summoner) internal view returns (uint) {
        return __get_storage(305, _summoner);
    }
    function total_strolledDistance_ofCompanion_01 (uint _summoner) public view returns (uint) {
        return _get_total_strolledDistance_ofCompanion_01(_summoner);
    }

    //total_strolledDistance_ofCompanion_02, mse:306
    function _set_total_strolledDistance_ofCompanion_02 (uint _summoner, uint _value) internal {
        __set_storage(306, _summoner, _value);
    }
    function _add_total_strolledDistance_ofCompanion_02 (uint _summoner, uint _value) internal {
        __add_storage(306, _summoner, _value);
    }
    function _get_total_strolledDistance_ofCompanion_02 (uint _summoner) internal view returns (uint) {
        return __get_storage(306, _summoner);
    }
    function total_strolledDistance_ofCompanion_02 (uint _summoner) public view returns (uint) {
        return _get_total_strolledDistance_ofCompanion_02(_summoner);
    }

    //total_strolledDistance_ofCompanion_03, mse:307
    function _set_total_strolledDistance_ofCompanion_03 (uint _summoner, uint _value) internal {
        __set_storage(307, _summoner, _value);
    }
    function _add_total_strolledDistance_ofCompanion_03 (uint _summoner, uint _value) internal {
        __add_storage(307, _summoner, _value);
    }
    function _get_total_strolledDistance_ofCompanion_03 (uint _summoner) internal view returns (uint) {
        return __get_storage(307, _summoner);
    }
    function total_strolledDistance_ofCompanion_03 (uint _summoner) public view returns (uint) {
        return _get_total_strolledDistance_ofCompanion_03(_summoner);
    }
    
    //global_total_strolledDistance, mse:308
    function _add_global_total_strolledDistance (uint _value) internal {
        __add_storage(308, 0, _value);
    }
    function global_total_strolledDistance () external view returns (uint) {
        return __get_storage(308, 0);
    }

    //global_total_metSummoners, mse:309
    function _add_global_total_metSummoners (uint _value) internal {
        __add_storage(309, 0, _value);
    }
    function global_total_metSummoners () external view returns (uint) {
        return __get_storage(309, 0);
    }

    
    //getter
    function get_strollInfo (uint _summoner) external view returns (uint[26] memory) {
        uint[26] memory _res;
        if (isStrolling[_summoner]){
            _res[0] = 1;
        } else {
            _res[0] = 0;
        }
        //_res[1] = total_strolledDistance[_summoner];
        _res[1] = total_strolledDistance(_summoner);
        //_res[2] = total_strolledDistance_ofCompanion[_summoner][1];
        //_res[3] = total_strolledDistance_ofCompanion[_summoner][2];
        //_res[4] = total_strolledDistance_ofCompanion[_summoner][3];
        _res[2] = total_strolledDistance_ofCompanion_01(_summoner);
        _res[3] = total_strolledDistance_ofCompanion_02(_summoner);
        _res[4] = total_strolledDistance_ofCompanion_03(_summoner);
        //_res[5] = total_metSummoners[_summoner];
        _res[5] = total_metSummoners(_summoner);
        _res[6] = metSummoners[_summoner][0];
        _res[7] = metSummoners[_summoner][1];
        _res[8] = metSummoners[_summoner][2];
        _res[9] = metSummoners[_summoner][3];
        _res[10] = metSummoners[_summoner][4];
        _res[11] = total_strolling_direction[1];
        _res[12] = total_strolling_direction[2];
        _res[13] = total_strolling_direction[3];
        _res[14] = total_strolling_direction[4];
        _res[15] = total_strolling_companion[1];
        _res[16] = total_strolling_companion[2];
        _res[17] = total_strolling_companion[3];
        //_res[18] = stroll_level[_summoner];
        _res[18] = stroll_level(_summoner);
        //_res[19] = met_level[_summoner];
        _res[19] = met_level(_summoner);
        _res[20] = direction[_summoner];
        _res[21] = companion[_summoner];
        _res[22] = get_reminingSec(_summoner);
        _res[23] = get_strollingDistance(_summoner);
        if (check_strollEndable(_summoner)) {
            _res[24] = 1;
        } else {
            _res[24] = 0;
        }
        _res[25] = get_coolingSec(_summoner);
        return _res;
    }
    
    //variants
    uint public stroll_sec = 4 * 60 * 60;   // 4 hr
    uint public stroll_interval_sec = 16 * 60 * 60; // 16 hr
    uint public level_limit = 5;
    
    //set variants
    function _set_stroll_sec(uint _value) external onlyOwner {
        stroll_sec = _value;
    }
    function _set_stroll_interval_sec(uint _value) external onlyOwner {
        stroll_interval_sec = _value;
    }
    function _set_level_limit(uint _value) external onlyOwner {
        level_limit = _value;
    }
    
    //get_SPEED
    function _get_SPEED () internal view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        return mp.SPEED();
    }
    
    //get_rnd
    function _get_rnd (uint _summoner, uint _number) internal view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        return mfs.dn(_summoner, _number);
    }
    
    //start stroll
    function startStroll (
        uint _summoner, 
        uint _direction, 
        uint _companion, 
        uint _drink
    ) external nonReentrant whenNotPaused {
        require(_check_summoner_start(_summoner, msg.sender));
        require(_direction>=1 && _direction<=4);
        require(_companion>=1 && _companion<=3);
        require(_drink>=1 && _drink<=4);
        require(_check_companion(msg.sender, _companion));
        _write_strollInfo(_summoner, _direction, _companion, _drink);
        _reset_metSummoners(_summoner);
        _update_summonerStatus_start(_summoner);
    }
    
    //sub functions
    function _check_summoner_start (uint _summoner, address _address) internal view returns (bool) {
        require(isActive);
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        require(mp.isPaused() == false);
        require(ms.inHouse(_summoner));
        require(mfs.check_owner(_summoner, _address));
        require(ms.level(_summoner) >= level_limit);
        require(mfs.calc_satiety(_summoner) >= 50 && mfs.calc_happy(_summoner) >= 50);
        require(ms.working_status(_summoner) == 0);
        /*
        require(
            ms.mining_status(_summoner) == 0 
            && ms.farming_status(_summoner) == 0 
            && ms.crafting_status(_summoner) == 0
            && ms.practice_status(_summoner) == 0
        );
        */
        address _owner = mfs.get_owner(_summoner);
        require(
            mfs.get_balance_of_type_specific(_owner, waterBottle_item_type) > 0
            || mfs.get_balance_of_type_specific(_owner, waterBottle_item_type +64) > 0
            || mfs.get_balance_of_type_specific(_owner, waterBottle_item_type +128) > 0
        );
        require(isStrolling[_summoner]==false);
        require( (block.timestamp - end_time[_summoner]) * _get_SPEED() / 100 >= stroll_interval_sec);
        return true;
    }
    function _check_companion (address _wallet, uint _companion) internal view returns (bool) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        uint _item_type;
        if (_companion == 1) {
            _item_type = 2;
        } else if (_companion == 2) {
            _item_type = 20;
        } else if (_companion == 3) {
            _item_type = 37;
        }
        bool _res;
        if (
            mfs.get_balance_of_type_specific(_wallet, _item_type)>0
            || mfs.get_balance_of_type_specific(_wallet, _item_type+64)>0
            || mfs.get_balance_of_type_specific(_wallet, _item_type+128)>0
        ) {
            _res = true;
        }
        return _res;
    }
    function _write_strollInfo (
        uint _summoner, 
        uint _direction, 
        uint _companion, 
        uint _drink
    ) internal {
        isStrolling[_summoner] = true;
        start_time[_summoner] = block.timestamp;
        direction[_summoner] = _direction;
        companion[_summoner] = _companion;
        drink[_summoner] = _drink;
        uint _direction_and_companion = _direction * 1 + _companion * 10;
        strolledSummoners[_direction_and_companion].add(_summoner);
        total_strolling_direction[_direction] += 1;
        total_strolling_companion[_companion] += 1;
    }
    function _reset_metSummoners (uint _summoner) internal {
        metSummoners[_summoner][0] = 0;
        metSummoners[_summoner][1] = 0;
        metSummoners[_summoner][2] = 0;
        metSummoners[_summoner][3] = 0;
        metSummoners[_summoner][4] = 0;
    }
    function _update_summonerStatus_start (uint _summoner) internal {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        //ms.set_inHouse(_summoner, false);
        ms.set_working_status(_summoner, 5);
    }
    
    //check stroll endable
    function check_strollEndable (uint _summoner) public view returns (bool) {
        bool _res;
        if ( (block.timestamp - start_time[_summoner]) * _get_SPEED() / 100 > stroll_sec) {
            _res = true;
        }
        return _res;
    }

    //end stroll
    event End_Stroll (uint indexed _summoner, uint _strolledDistance);
    event Summoners_Met (uint indexed _summoner, uint _summoner_met, bool _isFirstTime);
    function endStroll (uint _summoner) external nonReentrant whenNotPaused {
        require(_check_summoner_end(_summoner, msg.sender));
        _update_metSummoners(_summoner);
        _update_total_metSummoners(_summoner);
        _update_totalDistance(_summoner);
        _update_meetTimes(_summoner);
        _try_itemMinting(_summoner);
        _clear_strollInfo(_summoner);
        _update_summonerStatus_end(_summoner);
    }
    
    //sub functions
    function _check_summoner_end (uint _summoner, address _address) internal view returns (bool) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        require(mp.isPaused() == false);
        require(ms.working_status(_summoner) == 5);
        require(isStrolling[_summoner]);
        require(mfs.check_owner(_summoner, _address));
        require(check_strollEndable(_summoner));
        return true;
    }
    function _update_metSummoners (uint _summoner) internal {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        //get total number of summoners in the same direction and companion
        uint _direction_and_companion = direction[_summoner] * 1 + companion[_summoner] * 10;
        uint _total_strolling_inSame = strolledSummoners[_direction_and_companion].length();
        uint _rnd;
        uint _summoner_met;
        //choose random summoner 5 times
        for (uint i=0; i<5; i++) {
            //select random summoner
            //_summoner_met = mfs.dn(_summoner + i, _total_strolling_inSame);
            _rnd = mfs.dn(_summoner + i, _total_strolling_inSame);
            _summoner_met = strolledSummoners[_direction_and_companion].at(_rnd);
            //check not exist in the list and the list is not full each other
            if (
                _summoner != _summoner_met
                && __check_notExistInMetSummoners(_summoner, _summoner_met)
                && __check_notExistInMetSummoners(_summoner_met, _summoner)
                && __check_notFullOfMetSummoners(_summoner)
                && __check_notFullOfMetSummoners(_summoner_met)
            ){
                //append met summoner to the list of summoner
                for (uint j=0; j<5; j++) {
                    if (metSummoners[_summoner][j] == 0) {
                        metSummoners[_summoner][j] = _summoner_met;
                        break;
                    }
                }
                //append summoner to the list of met summoner
                for (uint k=0; k<5; k++) {
                    if (metSummoners[_summoner_met][k] == 0) {
                        metSummoners[_summoner_met][k] = _summoner;
                        break;
                    }
                }
            }
        }
    }
    function __check_notExistInMetSummoners (uint _summoner, uint _summoner_met) internal view returns (bool) {
        bool _res;
        if (
            metSummoners[_summoner][0] != _summoner_met
            && metSummoners[_summoner][1] != _summoner_met
            && metSummoners[_summoner][2] != _summoner_met
            && metSummoners[_summoner][3] != _summoner_met
            && metSummoners[_summoner][4] != _summoner_met
        ){
            _res = true;
        }
        return _res;
    }
    function __check_notFullOfMetSummoners (uint _summoner) internal view returns (bool) {
        bool _res;
        if (
            metSummoners[_summoner][0] == 0
            || metSummoners[_summoner][1] == 0
            || metSummoners[_summoner][2] == 0
            || metSummoners[_summoner][3] == 0
            || metSummoners[_summoner][4] == 0
        ){
            _res = true;
        }
        return _res;
    }
    function _update_total_metSummoners (uint _summoner) internal {
        uint _count_newMeet = 0;
        uint _summoner_met;
        for (uint i; i<5; i++) {
            _summoner_met = metSummoners[_summoner][i];
            if (
                _summoner_met != 0
                && summoner2summoner_metTime[_summoner][_summoner_met] == 0
                //&& summoner2summoner_metTime[_summoner_met][_summoner] == 0
            ) {
                _count_newMeet += 1;
            }
        }
        //total_metSummoners[_summoner] += _count_newMeet;
        _add_total_metSummoners(_summoner, _count_newMeet);
        _add_global_total_metSummoners(_count_newMeet);
    }
    function _update_totalDistance (uint _summoner) internal {
        uint _distance;
        _distance = block.timestamp - start_time[_summoner];
        _distance = _distance * _get_SPEED() / 100;
        if (_distance > stroll_sec) {
            _distance = stroll_sec;    //limit 4 hr
        }
        _distance = _distance * 500 / 3600; // meter, 500 m/hr
        uint _percentx100 = __get_boostRate_percentx100(_summoner);
        _distance += _distance * _percentx100 / 10000;
        //total_strolledDistance[_summoner] += _distance;
        //_set_total_strolledDistance(_summoner, get_total_strolledDistance(_summoner) + _distance);
        _add_total_strolledDistance(_summoner, _distance);
        _add_global_total_strolledDistance(_distance);
        //total_strolledDistance_ofCompanion[_summoner][companion[_summoner]] += _distance;
        if (companion[_summoner] == 1) {
            //_set_total_strolledDistance_ofCompanion_01(_summoner, get_total_strolledDistance_ofCompanion_01(_summoner) + _distance);
            _add_total_strolledDistance_ofCompanion_01(_summoner, _distance);
        } else if (companion[_summoner] == 2) {
            //_set_total_strolledDistance_ofCompanion_02(_summoner, get_total_strolledDistance_ofCompanion_02(_summoner) + _distance);
            _add_total_strolledDistance_ofCompanion_02(_summoner, _distance);
        } else if (companion[_summoner] == 3) {
            //_set_total_strolledDistance_ofCompanion_03(_summoner, get_total_strolledDistance_ofCompanion_03(_summoner) + _distance);
            _add_total_strolledDistance_ofCompanion_03(_summoner, _distance);
        }
        emit End_Stroll(_summoner, _distance);
    }
    function __get_boostRate_percentx100 (uint _summoner) internal view returns (uint) {
        uint _boostRate = 0;
        uint _summoner_met;
        for (uint i; i<5; i++) {
            _summoner_met = metSummoners[_summoner][i];
            if (_summoner_met == 0) {
                _boostRate += 0;
            } else if (
                summoner2summoner_metTime[_summoner][_summoner_met] == 0
                && summoner2summoner_metTime[_summoner_met][_summoner] == 0
            ) {
                if (drink[_summoner] == drink[_summoner_met]) {
                    _boostRate += 1000;  // +10%
                } else {
                    _boostRate += 1500;  // +15%
                }
            } else {
                if (drink[_summoner] == drink[_summoner_met]) {
                    _boostRate += 500;   // +5%
                } else {
                    _boostRate += 750;   // +7.5%
                }
            }
        }
        //when nobody met, low frequency bonus
        if (_boostRate == 0) {
            uint _rnd = _get_rnd(_summoner, 100);
            if (_rnd < 1) {
                _boostRate *= 10000;    // 1%: +100%
            } else if (_rnd < 1+3) {
                _boostRate *= 5000;     // 3%: +50%
            } else if (_rnd < 1+3+10) {
                _boostRate *= 2000;     // 10%: +20%
            }
        }
        return _boostRate;
    }
    function _update_meetTimes (uint _summoner) internal {
        uint _summoner_met;
        for (uint i; i<5; i++) {
            _summoner_met = metSummoners[_summoner][i];
            if (_summoner_met != 0) {
                //check first time met
                bool _isFirstTime;
                if (
                    summoner2summoner_metTime[_summoner][_summoner_met] == 0
                    && summoner2summoner_metTime[_summoner_met][_summoner] == 0
                ) {
                    _isFirstTime = true;
                }
                //update met time
                summoner2summoner_metTime[_summoner][_summoner_met] = block.timestamp;
                summoner2summoner_metTime[_summoner_met][_summoner] = block.timestamp;
                emit Summoners_Met(_summoner, _summoner_met, _isFirstTime);
            }
        }
    }
    function _try_itemMinting (uint _summoner) internal {
        //uint _total_distance = total_strolledDistance[_summoner];
        uint _total_distance = _get_total_strolledDistance(_summoner);
        //uint _total_metSummoners = total_metSummoners[_summoner];
        uint _total_metSummoners = _get_total_metSummoners(_summoner);
        //uint _stroll_level = stroll_level[_summoner];
        uint _stroll_level = _get_stroll_level(_summoner);
        //uint _met_level = met_level[_summoner];
        uint _met_level = _get_met_level(_summoner);
        if (
            (_stroll_level <= 1 && _total_distance >= 6000)
            || (_stroll_level <= 2 && _total_distance >= 20000)
            || (_stroll_level <= 3 && _total_distance >= 40000)
            || (_stroll_level <= 4 && _total_distance >= 64000)
            || (_stroll_level <= 5 && _total_distance >= 92800)
            || (_stroll_level <= 6 && _total_distance >= 127360)
            || (_stroll_level <= 7 && _total_distance >= 168832)
            || (_stroll_level <= 8 && _total_distance >= 218598)
            || (_stroll_level <= 9 && _total_distance >= 278318)
            || (_stroll_level <= 10 && _total_distance >= 349982)
            || (_stroll_level <= 11 && _total_distance >= 435978)
            || (_stroll_level <= 12 && _total_distance >= 539174)
            || (_stroll_level <= 13 && _total_distance >= 663008)
            || (_stroll_level <= 14 && _total_distance >= 811610)
            || (_stroll_level <= 15 && _total_distance >= 989932)
            || (_stroll_level <= 16 && _total_distance >= 1203918)
        ) {
            //stroll_level[_summoner] += 1;
            _add_stroll_level(_summoner, 1);
            __mint_randomTwinkle(_summoner);
        } else if (
            (_met_level <= 1 && _total_metSummoners >= 10)
            || (_met_level <= 2 && _total_metSummoners >= 30)
            || (_met_level <= 3 && _total_metSummoners >= 70)
            || (_met_level <= 4 && _total_metSummoners >= 150)
            || (_met_level <= 5 && _total_metSummoners >= 310)
            || (_met_level <= 6 && _total_metSummoners >= 630)
            || (_met_level <= 7 && _total_metSummoners >= 1270)
            || (_met_level <= 8 && _total_metSummoners >= 2550)
            || (_met_level <= 9 && _total_metSummoners >= 5110)
            || (_met_level <= 10 && _total_metSummoners >= 10230)
            || (_met_level <= 11 && _total_metSummoners >= 20470)
            || (_met_level <= 12 && _total_metSummoners >= 40950)
        ) {
            //met_level[_summoner] += 1;
            _add_met_level(_summoner, 1);
            __mint_randomTwinkle(_summoner);
        }
    }
    function __mint_randomTwinkle (uint _summoner) internal {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Craft mc = Murasaki_Craft(ma.address_Murasaki_Craft());
        address _owner = mfs.get_owner(_summoner);
        uint _seed = mfs.seed(_summoner);
        uint _rnd = mfs.dn(_seed + _summoner, 3);
        uint _item_type;
        if (_rnd == 0) {
            _item_type = 251;
        } else if (_rnd == 1) {
            _item_type = 256;
        } else if (_rnd == 2) {
            _item_type = 261;
        }
        uint _item_subtype = mfs.d8(_seed + _summoner);
        string memory _memo = "";
        mc.craft(_item_type, _summoner, _owner, _seed, _memo, _item_subtype);
    }
    function _clear_strollInfo (uint _summoner) internal {
        isStrolling[_summoner] = false;
        end_time[_summoner] = block.timestamp;
        total_strolling_direction[ direction[_summoner] ] -= 1;
        total_strolling_companion[ companion[_summoner] ] -= 1;
        uint _direction_and_companion = direction[_summoner] * 1 + companion[_summoner] * 10;
        strolledSummoners[_direction_and_companion].remove(_summoner);
        direction[_summoner] = 0;
        companion[_summoner] = 0;
        drink[_summoner] = 0;
    }
    function _update_summonerStatus_end (uint _summoner) internal {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        //ms.set_inHouse(_summoner, true);
        ms.set_working_status(_summoner, 0);
        //update working time
        uint _delta_sec = (block.timestamp - start_time[_summoner]) * _get_SPEED() / 100;
        uint _last_grooming_time_plus_working_time = ms.last_grooming_time_plus_working_time(_summoner) + _delta_sec;
        ms.set_last_grooming_time_plus_working_time(_summoner, _last_grooming_time_plus_working_time);
    }
    
    //get distribution of directions
    function get_distributionOfDirections () external view returns (uint[5] memory) {
        uint[5] memory _res;
        for (uint i=1; i<=4; i++) {
            _res[i] = total_strolling_direction[i];
        }
        return _res;
    }
    
    //get distribution of companions
    function get_distributionOfCompanions () external view returns (uint[4] memory) {
        uint[4] memory _res;
        for (uint i=1; i<=3; i++) {
            _res[i] = total_strolling_companion[i];
        }
        return _res;
    }
    
    //get remining sec
    function get_reminingSec (uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        uint _reminingSec;
        if (ms.working_status(_summoner) != 5) {
            _reminingSec = 0;
        } else {
            if ( (block.timestamp - start_time[_summoner]) * _get_SPEED() / 100 > stroll_sec) {
                _reminingSec = 0;
            } else {
                _reminingSec = stroll_sec - ( (block.timestamp - start_time[_summoner]) * _get_SPEED() / 100 );
            }
        }
        return _reminingSec;
    }
    
    //get strolling distance
    function get_strollingDistance (uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        uint _distance;
        if (ms.working_status(_summoner) != 5) {
            _distance = 0;
        } else {
            _distance = block.timestamp - start_time[_summoner];
            _distance = _distance * _get_SPEED() / 100;
            if (_distance > stroll_sec) {
                _distance = stroll_sec;    //limit 4 hr
            }
            _distance = _distance * 500 / 3600; // meter, 500 m/hr
            uint _percentx100 = __get_boostRate_percentx100(_summoner);
            _distance += _distance * _percentx100 / 10000;
        }
        return _distance;
    }
    
    //get cooling sec
    function get_coolingSec (uint _summoner) public view returns (uint) {
        uint _now = block.timestamp;
        uint _deltaSec = _now - end_time[_summoner];
        uint _coolingSec;
        if (_deltaSec >= stroll_interval_sec) {
            _coolingSec = 0;
        } else {
            _coolingSec = stroll_interval_sec - _deltaSec;
        }
        return _coolingSec;
    }
}


//---Pippel_Function

contract Pippel_Function is Ownable, ReentrancyGuard, Pausable {

    //pausable
    function pause() external onlyOwner {
        _pause();
    }
    function unpause() external onlyOwner {
        _unpause();
    }

    // address
    address public address_Murasaki_Address;
    function _set_Murasaki_Address(address _address) external onlyOwner {
        address_Murasaki_Address = _address;
    }
    
    // salt
    uint private salt = 6539;
    function _update_salt(uint _summoner) external onlyOwner {
        salt = _seed(_summoner);
    }
    
    // pippel appearance hr
    uint public pippel_hr = 3;
    function _set_pippel_hr (uint _val) external onlyOwner {
        pippel_hr = _val;
    }
    
    // interval
    mapping (uint => uint) private lastMintTime;
    uint public mintInterval = 3600 + 300;   //sec, 1hr + 5min
    function _set_mintInterval(uint _val) external onlyOwner {
        mintInterval = _val;
    }
    
    // set interval
    uint public pippel_interval = 86400 * 2;
    function _set_pippel_interval (uint _val) external onlyOwner {
        pippel_interval = _val;
    }
    
    // store last mint pippel type for each player
    mapping (uint => uint) private lastMintType;
    
    // flag, enable calling next hour of pippel appearing
    bool private flag_enableCallPippelHour;
    function _set_enableCallPippelHour(bool _bool) external onlyOwner {
        flag_enableCallPippelHour = _bool;
    }
    
    // check pippel appearance
    function check_pippel (uint _summoner) public view returns (bool) {        
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        bool _bool;
        // prepare interval
        uint _interval = block.timestamp - lastMintTime[_summoner];
        // current hour converted from block.number, 0-23
        (,,,uint _current_hr,,) = parseTimestamp(block.timestamp);
        // random hour resets every day, 0-23
        uint _random_hr = _dn(_summoner, 24);
        // modify hours by pippel_hr, / (appearancing hr)
        _current_hr /= pippel_hr;
        _random_hr /= pippel_hr;
        // call daily flower type
        uint _dailyType = _call_dailyFlowerType();
        // when current hr == random hr, pippel appearing for 1 hr
        // when trial version, no pippel
        if (
            _random_hr == _current_hr 
            && lastMintType[_summoner] != _dailyType
            && _interval >= mintInterval
            && mfs.isTrial() == false
        ) {
            _bool = true;
        }
        return _bool;
    }

    // call next pippel hour
    // require flag
    function call_nextPippelHour(uint _summoner) external view returns (uint) {
        require(flag_enableCallPippelHour);
        uint _random_hr = _dn(_summoner, 24);
        return _random_hr;
    }
    
    // mint daily flower from pippel
    event Mint_Pippel (uint indexed _summoner, uint _flower_type, uint _rarity_type);
    function mint_pippel (uint _summoner) external nonReentrant whenNotPaused {
        // check pippel appearance
        require(check_pippel(_summoner));
        // check _summoner, msg.sender
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        require(mp.isPaused() == false);
        require(ms.inHouse(_summoner));
        require(mfs.check_owner(_summoner, msg.sender));
        // mint random flower
        _mint_pippel(_summoner);
        // update last mint time
        lastMintTime[_summoner] = block.timestamp;
    }
    
    // call tba
    function call_tba (uint _summoner) external view returns (address) {
        return _call_tba(_summoner);
    }

    // internal
    // mint daily flower NFT into TBA
    function _mint_pippel (uint _summoner) internal {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Pippel_NFT pn = Pippel_NFT(ma.address_Pippel_NFT());

        // prepare tba
        address _tba = _call_tba(_summoner);

        // get daily flower id
        uint _flower_type = _call_dailyFlowerType();

        // prepare other parameters
        uint _flowerSeed = mfs.seed(_summoner);
        string memory _memo = "meet a pippel";

        // define rarity
        uint _rarity_type = _get_flowerRarity(_summoner);

        // mint pippel NFT
        pn.mint(
            _flower_type,
            _summoner,
            _tba,
            _flowerSeed,
            _memo,
            _rarity_type
        );
        
        // event
        emit Mint_Pippel(_summoner, _flower_type, _rarity_type);

        // store last mint type
        lastMintType[_summoner] = _flower_type;
    }
    // prepare tba
    function _call_tba (uint _summoner) internal view returns (address) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        IERC6551Registry _ERC6551Registry = IERC6551Registry(ma.address_Murasaki_TBARegistry());
        address _tba = _ERC6551Registry.account(
            ma.address_Murasaki_TBAAccount(), // ERC6551Account address
            //***TODO*** testnet
            4369,  // chain id
            ma.address_Murasaki_Main(), // token contract address, ma
            _summoner,  // token id
            6539    // salt
        );
        return _tba;
    }
    // prepare daily flower type
    function _call_dailyFlowerType () internal view returns (uint) {
        uint _now = block.timestamp;
        (,uint _month, uint _day,,,) = parseTimestamp(_now);
        uint _flower_type = day2id(_month, _day);
        return _flower_type;
    }
    // define flower rarity
    function _get_flowerRarity (uint _summoner) internal view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        uint _rnd = mfs.dn(_summoner, 100);
        uint _rarity_type;
        if (_rnd < 10) {        // 10%, closed
            _rarity_type = 1;
        } else if (_rnd < 30) { // 20%, opening
            _rarity_type = 2;
        } else if (_rnd < 70) { // 40%, blossoming
            _rarity_type = 3;
        } else if (_rnd < 90) { // 20%, blooming
            _rarity_type = 4;
        } else if (_rnd < 100) { // 10% bloomed
            _rarity_type = 5;
        }
        return _rarity_type;
    }

    // UNIX -> UTC+0, supported by ChatGPT
    function parseTimestamp(uint256 timestamp) public pure returns (
            uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second
    ) {
        uint256 secondsInDay = 86400;
        uint256 secondsInHour = 3600;
        uint256 secondsInMinute = 60;

        // sec from 1970/01/01
        uint256 secondsElapsed = timestamp;

        // check leap year
        bool isLeapYear = isLeap(uint256(1970));

        // calc year
        uint256 secondsInYear = isLeapYear ? 31622400 : 31536000;
        year = 1970;
        while (secondsElapsed >= secondsInYear) {
            secondsElapsed -= secondsInYear;
            year++;
            isLeapYear = isLeap(uint256(year));
            secondsInYear = isLeapYear ? 31622400 : 31536000;
        }

        // calc month and day
        uint256[] memory daysInMonth = new uint256[](12);
        daysInMonth[0] = 2678400; // 31日
        daysInMonth[1] = isLeapYear ? 2505600 : 2419200; // 28d or 29d
        daysInMonth[2] = 2678400; // 31日
        daysInMonth[3] = 2592000; // 30日
        daysInMonth[4] = 2678400; // 31日
        daysInMonth[5] = 2592000; // 30日
        daysInMonth[6] = 2678400; // 31日
        daysInMonth[7] = 2678400; // 31日
        daysInMonth[8] = 2592000; // 30日
        daysInMonth[9] = 2678400; // 31日
        daysInMonth[10] = 2592000; // 30日
        daysInMonth[11] = 2678400; // 31日

        for (month = 0; month < 12; month++) {
            if (secondsElapsed < daysInMonth[month]) {
                month++;
                break;
            }
            secondsElapsed -= daysInMonth[month];
        }

        // calc day
        day = uint8(secondsElapsed / secondsInDay) + 1;
        secondsElapsed %= secondsInDay;

        // calc hr, min, sec
        hour = uint8(secondsElapsed / secondsInHour);
        secondsElapsed %= secondsInHour;
        minute = uint8(secondsElapsed / secondsInMinute);
        second = uint8(secondsElapsed % secondsInMinute);
    }
    function isLeap(uint256 year) internal pure returns (bool) {
        return (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0));
    }
    
    // month/day -> id[1-366], supported by ChatGPT
    function day2id(uint256 month, uint256 day) public pure returns (uint256) {
        require(month >= 1 && month <= 12, "Invalid month");
        require(day >= 1 && day <= 31, "Invalid day");

        uint8[12] memory daysInMonth = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
        uint256 dayCount = 0;

        for (uint256 i = 0; i < month - 1; i++) {
            //require(day <= daysInMonth[i], "Invalid day for the given month");
            dayCount += daysInMonth[i];
        }

        return dayCount + day;
    }

    // id[1-366] -> month/day, supported by ChatGPT
    function id2day(uint256 id) public pure returns (uint256 month, uint256 day) {
        require(id >= 1 && id <= 366, "Invalid id");

        uint8[12] memory daysInMonth = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
        
        uint256 currentMonth = 0;
        uint256 remainingDays = id;
        
        while (remainingDays > daysInMonth[currentMonth]) {
            remainingDays -= daysInMonth[currentMonth];
            currentMonth++;
        }
        
        // Add 1 to month and day to convert from 0-based index to 1-based index
        month = currentMonth + 1;
        day = remainingDays;
        
        return (month, day);
    }

    // random number
    // reset per a day, depneds on summonerId and msg.sender, and salt
    // update: ignore msg.sender to check pippel from other player
    // depends on summonerId and salt
    function _dn(uint _summoner, uint _number) internal view returns (uint) {
        return _seed(_summoner) % _number;
    }
    function _random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }
    function _seed(uint _summoner) internal view returns (uint rand) {
        rand = _random(
            string(
                abi.encodePacked(
                    _summoner,
                    //msg.sender,
                    (block.timestamp / pippel_interval),
                    salt
                )
            )
        );
    }

    // calc pippel score
    // 10 pippel score = 1 fluffy score = 0.01 LUK
    function calc_pippelScore (uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Pippel_NFT pn = Pippel_NFT(ma.address_Pippel_NFT());
        // call tba of summoner and call number of rarity flowers of tba
        // *not owner's wallet, but summoner's tba
        address _tba = _call_tba(_summoner);
        uint[10] memory _scores = pn.get_balance_of_rarity(_tba);
        uint _score;
        _score += _scores[1] * 6;   // closed, -40%, +6
        _score += _scores[2] * 8;   // opening, -20%, +8
        _score += _scores[3] * 10;  // blossoming, 0%, +10
        _score += _scores[4] * 12;  // blooming, +20%, +12
        _score += _scores[5] * 14;  // bloomed, +40%, +14
        return _score;
    }
}



//---Pippel_NFT

contract Pippel_NFT is ERC2665, Ownable, Pausable {

    //pausable
    function pause() external onlyOwner {
        _pause();
    }
    function unpause() external onlyOwner {
        _unpause();
    }

    //permitted address
    mapping(address => bool) private permitted_address;

    //admin, add or remove permitted_address
    function _add_permitted_address(address _address) external onlyOwner {
        permitted_address[_address] = true;
    }
    function _remove_permitted_address(address _address) external onlyOwner {
        permitted_address[_address] = false;
    }

    //admin. withdraw
    function withdraw(address rec)public onlyOwner{
        payable(rec).transfer(address(this).balance);
    }
    
    //codex address
    address public address_murasaki_pippel_codex;
    function _set_codex_address (address _address) external onlyOwner {
        address_murasaki_pippel_codex = _address;
    }

    using EnumerableSet for EnumerableSet.UintSet;
    mapping(address => EnumerableSet.UintSet) private mySet;

    //name
    constructor() ERC2665("Murasaki Pippel", "MP") {}

    // struct, flower
    uint public next_item = 1;
    struct flower {
        uint mint_time;
        uint mint_summoner;
        string memo;
        uint flower_type;
        uint rarity_type;
        uint seed;
    }
    mapping(uint => flower) public flowers;
    
    // wallet info
    mapping(address => uint[500]) public balance_of_type;
    mapping(address => uint[10]) public balance_of_rarity;

    // flower statics
    mapping(uint => uint) public mintCount_flowerType;  // flower_type => mint count
    mapping(uint => uint) public mintCount_rarity;      // rarity_type => mint count
    
    //mint limit
    uint public mintLimit_perFlowerType = 900000;
    function _set_mintLimit_perFlowerType(uint _value) external onlyOwner {
        mintLimit_perFlowerType = _value;
    }

    //override ERC721 transfer, 
    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override {
        ERC2665._transfer(from, to, tokenId);
        uint _flower_type = flowers[tokenId].flower_type;
        uint _rarity_type = flowers[tokenId].rarity_type;
        balance_of_type[from][_flower_type] -= 1;
        balance_of_type[to][_flower_type] += 1;
        balance_of_rarity[from][_rarity_type] -= 1;
        balance_of_rarity[to][_rarity_type] += 1;
        mySet[from].remove(tokenId);
        mySet[to].add(tokenId);
    }

    //override ERC721 burn
    function _burn(uint256 tokenId) internal virtual override {
        uint _flower_type = flowers[tokenId].flower_type;
        uint _rarity_type = flowers[tokenId].rarity_type;
        address _owner = ERC2665.ownerOf(tokenId);
        balance_of_type[_owner][_flower_type] -= 1;
        balance_of_rarity[_owner][_rarity_type] -= 1;
        mySet[_owner].remove(tokenId);
        //ERC721._burn(tokenId);
        ERC2665._transfer(_owner, address(this), tokenId);
    }

    //burn
    function burn(uint256 tokenId) external whenNotPaused {
        require(permitted_address[msg.sender] == true);
        _burn(tokenId);
    }

    //mint
    function mint(
        uint _flower_type, 
        uint _summoner, 
        address _wallet, 
        uint _seed, 
        string memory _memo,
        uint _rarity_type
    ) external whenNotPaused {
        require(permitted_address[msg.sender] == true);
        require(mintCount_flowerType[_flower_type] < mintLimit_perFlowerType);
        uint _now = block.timestamp;
        uint _minting_flowerId = next_item;
        flowers[_minting_flowerId] = flower(
            _now, 
            _summoner, 
            _memo, 
            _flower_type,
            _rarity_type,
            _seed
        );
        balance_of_type[_wallet][_flower_type] += 1;
        balance_of_rarity[_wallet][_rarity_type] += 1;
        mintCount_flowerType[_flower_type]++;
        mintCount_rarity[_rarity_type]++;
        mySet[_wallet].add(_minting_flowerId);
        next_item++;
        _safeMint(_wallet, _minting_flowerId);
    }
    
    // count number of flower types
    function number_of_flowerTypes (address _wallet) external view returns (uint) {
        uint _sum = 0;
        for (uint i = 0; i < 500; i++) {
            if (balance_of_type[_wallet][i] > 0) {
                _sum += 1;
            }
        }
        return _sum;
    }
    
    // call flower name
    function call_flowerName (uint _flowerId) public view returns (string memory) {
        uint _flower_type = flowers[_flowerId].flower_type;
        uint _rarity_type = flowers[_flowerId].rarity_type;
        Pippel_Codex pc = Pippel_Codex(address_murasaki_pippel_codex);
        string memory _flower_name = pc.daily_flower_names(_flower_type);
        string memory _flower_rarity = pc.flower_rarity(_rarity_type);
        return string(
            abi.encodePacked(
                _flower_rarity,
                " ",
                _flower_name
            )
        );
    }
    
    /// @dev Returns list the total number of listed summoners of the given user.
    function myListLength(address user) public view returns (uint) {
        return mySet[user].length();
    }

    /// @dev Returns the ids and the prices of the listed summoners of the given user.
    function myListsAt(
        address user,
        uint start,
        uint count
    ) external view returns (uint[] memory rIds) {
        rIds = new uint[](count);
        for (uint idx = 0; idx < count; idx++) {
            rIds[idx] = mySet[user].at(start + idx);
        }
    }

    /// @dev Returns the ids and the prices of the listed summoners of the given user.
    function myListsAt_withItemType(
        address user,
        uint start,
        uint count
    ) external view returns (uint[] memory rIds) {
        rIds = new uint[](count*2);
        for (uint idx = 0; idx < count; idx++) {
            uint _id = mySet[user].at(start + idx);
            rIds[idx*2] = _id;
            flower memory _flower = flowers[_id];
            rIds[idx*2+1] = _flower.flower_type;
        }
    }
    function myListsAt_withItemTypeAndSubtype(
        address user,
        uint start,
        uint count
    ) external view returns (uint[] memory rIds) {
        rIds = new uint[](count*3);
        for (uint idx = 0; idx < count; idx++) {
            uint _id = mySet[user].at(start + idx);
            rIds[idx*3] = _id;
            flower memory _flower = flowers[_id];
            rIds[idx*3+1] = _flower.flower_type;
            rIds[idx*3+2] = _flower.rarity_type;
        }
    }
    
    //URI
    string public baseURI = "https://murasaki-san.com/src/json/pippel/";
    string public tailURI = ".json";
    function set_baseURI(string memory _string) external onlyOwner {
        baseURI = _string;
    }
    function set_tailURI(string memory _string) external onlyOwner {
        tailURI = _string;
    }
    function toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
    //override tokenURI
    function tokenURI (uint _tokenId) public view override returns (string memory) {
        require(_exists(_tokenId), "token must exist");
        uint _flower_type = flowers[_tokenId].flower_type;
        return string(
            abi.encodePacked(
                baseURI,
                toString(_flower_type),
                tailURI
            )
        );
    }

    //call items as array, need to write in Craft contract
    function get_balance_of_type(address _wallet) public view returns (uint[500] memory) {
        return balance_of_type[_wallet];
    }
    function balanceOfType(address _wallet, uint _item_type) external view returns (uint) {
        return balance_of_type[_wallet][_item_type];
    }
    function get_balance_of_rarity(address _wallet) public view returns (uint[10] memory) {
        return balance_of_rarity[_wallet];
    }

    // ### Transfer fees ###
    
    //noFee address
    mapping(address => bool) private noFee_address;
    
    //set transfer fee
    uint public TRANSFER_FEE = 50 * 10**18;   //wei
    
    //a wallet collecting fees
    address private bufferTreasury_address;
    
    //admin
    function _add_noFee_address(address _address) external onlyOwner {
        noFee_address[_address] = true;
    }
    function _remove_noFee_address(address _address) external onlyOwner {
        noFee_address[_address] = false;
    }
    function _set_transfer_fee(uint _value) external onlyOwner {
        TRANSFER_FEE = _value;
    }
    function _set_bufferTreasury_address(address _address) external onlyOwner {
        bufferTreasury_address = _address;
    }
    
    //override ERC2665
    //function getTransferFee(uint256 _tokenId) external view override returns (uint256) {
    function getTransferFee(uint256) external view override returns (uint256) {
        return TRANSFER_FEE;
    }
    //function getTransferFee(uint256 _tokenId, string calldata _currencySymbol) external view override returns (uint256) {
    function getTransferFee(uint256, string calldata) external view override returns (uint256) {
        return TRANSFER_FEE;
    }
    
    //override transfer functions
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override payable whenNotPaused {
        //added code, when not noFee address, require transfer fee
        if (noFee_address[from] == false && noFee_address[to] == false) {
            require(msg.value >= TRANSFER_FEE);
            payable(bufferTreasury_address).transfer(address(this).balance);
        }
        require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
        _transfer(from, to, tokenId);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override payable whenNotPaused {
        if (noFee_address[from] == false && noFee_address[to] == false) {
            require(msg.value >= TRANSFER_FEE);
            payable(bufferTreasury_address).transfer(address(this).balance);
        }
        safeTransferFrom(from, to, tokenId, "");
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public virtual override payable whenNotPaused {
        if (noFee_address[from] == false && noFee_address[to] == false) {
            require(msg.value >= TRANSFER_FEE);
            payable(bufferTreasury_address).transfer(address(this).balance);
        }
        require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
        _safeTransfer(from, to, tokenId, _data);
    }
}



//---Pippel_Codex

contract Pippel_Codex is Ownable, Pausable {

    //pausable
    function pause() external onlyOwner {
        _pause();
    }
    function unpause() external onlyOwner {
        _unpause();
    }

    // daily flower name, daily_flowers[_month][_day]
    string[367] public daily_flower_names;
    string[6] public flower_rarity;
    
    function call_dailyFlowerName (uint _id) external view returns (string memory) {
        return daily_flower_names[_id];
    }
    
    function call_flowerRarity(uint _id) external view returns (string memory) {
        return flower_rarity[_id];
    }
    
    function flowerNames () external view returns (string[367] memory) {
        return daily_flower_names;
    }
    
    function flowerRarities () external view returns (string[6] memory) {
        return flower_rarity;
    }
    
    // prepare dictionary of dailyFlowerName
    constructor() {
        flower_rarity = [
            "",
            "Closed",
            "Opening",
            "Blossoming",
            "Blooming",
            "Bloomed"
        ];
        daily_flower_names = [
            "",
            "Snow Drop",
            "Camellia",
            "Forsythia",
            "Hyacinth",
            "Hepatica",
            "Violet",
            "Plum",
            "Purple Violet",
            "Yellow Violet",
            "Box Tree",
            "Arbor Vitae",
            "Spring Camellia",
            "Cattleya",
            "Cyclamen",
            "Thorn",
            "Yellow Hyacinth",
            "Shepherd's-Purse",
            "Indian Mallow",
            "Thunberg Spirea",
            "Pot Marigold",
            "Ivy",
            "Caraway",
            "Bullrusb",
            "Saffron Crocus ",
            "Cerastium",
            "Mimosa",
            "Rowan",
            "Black poplar",
            "Boronia",
            "Mash Marigold",
            "Spring Crocus",
            "Primrose",
            "Snowdrop",
            "Winter Aconite",
            "Blue Daisy",
            "Pulsatilla Cernua",
            "Rock Pine",
            "Winter Jasmine",
            "Strawberry Begonia",
            "Myrtle",
            "Pussy Willow",
            "Melissa",
            "Justica Procumbens",
            "Canary Grass",
            "Chamomile",
            "Edgeworthia",
            "Victor's Laurel",
            "Wild Flower",
            "Marsh Marigold",
            "Oak",
            "Kalmia",
            "Japanese cornel",
            "Hibiscus Syriacus",
            "Leucojum Aestivum",
            "Iceland Poppy",
            "Musk Rose",
            "Skunk Cabbage",
            "Star Of Arabia",
            "Barley",
            "Armeria",
            "Narcissus",
            "Alstroemeria",
            "Astragalus",
            "Raspberry",
            "Corn Flower",
            "Japanese snowball",
            "Wavy Bittercress",
            "Castanea",
            "Larch",
            "Canola Flower",
            "Ixeris",
            "Wax Flower",
            "Day Lily",
            "Sweet Alyssum",
            "Conium Macutatum",
            "Hall crabapple",
            "Bean Flower",
            "Asparagus",
            "Cape Jasmine",
            "Purple Tulip",
            "Magnolia",
            "Candytuft",
            "Gladiolus",
            "California Poppy",
            "Climbing Plant",
            "White Primrose",
            "Foxglove",
            "Robinia Hispida",
            "Burdock",
            "Sweet Pea",
            "Nigella Damascena",
            "Cherry Blossom",
            "Anemone",
            "Daffodil",
            "Red Anemone",
            "Fig Tree",
            "Adonis",
            "Nemophila",
            "Broom",
            "Cherry",
            "Periwinkle",
            "Jacob's Ladder",
            "Peach",
            "Golden Wave",
            "Peony",
            "Fen Orchid",
            "Catchfly",
            "German Iris",
            "Astragalus Sinicus",
            "Larspur",
            "Pear",
            "Forget-Me-Not",
            "Easter Cactus",
            "Balloon Flower",
            "Calceolaria",
            "Bluebell",
            "Japanese Cress",
            "Water Lily",
            "Red Primrose",
            "Gardenia",
            "Golden Chain",
            "Cowslip",
            "Buttercup",
            "Dandelion",
            "Garden Strawberry",
            "Lily Of The Valley",
            "Chinese Redbud",
            "Strawberry Leaf",
            "Rhododendron",
            "Prunus",
            "Flag Iris",
            "Apple",
            "Lilac",
            "Hawthorn",
            "Columbine",
            "Fish Mint",
            "Bridal Wreath",
            "Yellow Tulip",
            "Oxlip",
            "Aristata",
            "Wood Sorrel",
            "Red Larkspur",
            "Fuchsia",
            "Leaf Buds",
            "Heliotrope",
            "Pansy",
            "Olive",
            "Daisy",
            "Peppermint",
            "Coumbine",
            "Purple Lilac",
            "Lupine",
            "Old Rose",
            "Red Columbine",
            "Flax",
            "Damask Rose",
            "Bletilla",
            "Korean Iris",
            "Azalea",
            "Jasmine",
            "Aster",
            "Sweet William",
            "African Lily",
            "Mignonette",
            "Fox Glove",
            "Pimpernel",
            "Carnation",
            "Tube Rose",
            "Clover",
            "Thyme",
            "Sweet Brier",
            "Speedwell",
            "Evening Primrose",
            "Feverfew",
            "Holy Hock",
            "Garden Verbena",
            "Drumstick",
            "White Lilac",
            "Passion Flower",
            "Geranium",
            "Red Geranium",
            "Honey Suckle",
            "Astilbe",
            "Snap Dragon",
            "White Poppy",
            "Lily Magnolia",
            "Beard-Tongue",
            "Morning Glory",
            "Gooseberry",
            "Birdfoot",
            "Ivy Geranium",
            "Bellflower",
            "Asphodel",
            "Solanum",
            "Flower of Grass",
            "Phlox",
            "Briar Rose",
            "Stock Flower",
            "White Rose",
            "Moss Rose",
            "Aconite",
            "Eggplant",
            "Yellow Rose",
            "Rainbow Pink",
            "Rose",
            "Trillum",
            "Elder",
            "Wormwood",
            "Viburnum",
            "Fringed Pink",
            "Cactus",
            "Lime Tree",
            "Pumpkin",
            "Red Poppy",
            "Cornflower",
            "Flower of an Hour",
            "Corn",
            "Heath",
            "Torenia",
            "Tall Stewartia",
            "Spider Flower",
            "Cistus",
            "Mealy Sage",
            "Zonal Geranium",
            "Sweet Oleander",
            "Goldenrod",
            "Mallow",
            "Sunflower",
            "Tamarind",
            "Tulip Tree",
            "Holly Hock",
            "Rosa Campion",
            "Freesia",
            "Red Passionflower",
            "Spirea",
            "Linden Tree",
            "Calendula",
            "Flaming Flower",
            "Hypoxis Aurea",
            "Osmunda",
            "Eryngium",
            "Crape Myrtle",
            "Wall Germander",
            "Trumpet Creeper",
            "Tiger Flower",
            "Mexican Ivy",
            "Marguerite",
            "Geum",
            "Moonflower",
            "Nasturtium",
            "Orange",
            "Mustard",
            "Michaelmas Daisy",
            "Hyssop",
            "Aloe",
            "Clematis",
            "Butterfly bush",
            "Lycoris",
            "Dahlia",
            "Gentiana",
            "Erica",
            "Thistle",
            "Carex",
            "Rosemary",
            "Saffron",
            "Quaking Grass",
            "Yew Tree",
            "Buckwheat",
            "Animated Oat",
            "Date Plum",
            "Oak Tree",
            "Amaranthus",
            "Green Purslane",
            "Cedar",
            "Red Chrysanthemum",
            "Apricot",
            "Maple Tree",
            "Common Hop",
            "Palm Tree",
            "Hazel Tree",
            "Fir Tree",
            "Parsley",
            "Fennel",
            "Melon",
            "Lythrum",
            "Lingonberry",
            "Vanda",
            "Cosmos",
            "Sweet Basil",
            "Bur Marigold",
            "Grape",
            "Cranberry",
            "Balsam",
            "Yam",
            "Carlet Rose Mallow",
            "Arrowhead",
            "Thom Apple",
            "Protea",
            "Red Emperor Maple",
            "Den Phal",
            "Zinnia",
            "Rose of Sharon",
            "Crab Apple",
            "Lobelia",
            "Calla",
            "Medlar",
            "Lupin",
            "Bryony",
            "Crossandra",
            "Oncidium",
            "Common Agrimony",
            "Marigold",
            "Ragged Robin",
            "Myrrh",
            "Confederate Rose",
            "White Camellia",
            "Lemon",
            "Lemon Verbena",
            "Pine Immortality",
            "Crown Vetch",
            "Luculia",
            "Butterbur",
            "Hill Lily",
            "Aaron's Beard",
            "Bugloss",
            "Lantern Flower",
            "Korean Barberry",
            "Fern",
            "Pyracanth",
            "Rhus Continus",
            "Yarrow",
            "Phus",
            "China Aster",
            "Baccharis",
            "Reed ",
            "Tansy",
            "Moss",
            "Lavender",
            "Rumex",
            "Ambrosia",
            "Saxifraga",
            "Kalanchoe",
            "Reed",
            "Chrysanthemum",
            "Red Camellia",
            "Fig Marigold",
            "Cotton",
            "Pin Cushion",
            "Pine",
            "Winter Daphne",
            "Alder Tree",
            "Honey Plant",
            "Sage",
            "Gypsophila",
            "Pineapple",
            "Mint",
            "White Ash",
            "Platanus",
            "Mistletoe",
            "Holly",
            "Christmas Rose",
            "Chinese Plum",
            "Pomegranate",
            "Winter Cherry",
            "Carolina Allspice",
            "Chamaecyparis"
        ];
    }
}



//===Info==================================================================================================================



//---Murasaki_Info

contract Murasaki_Info is Ownable, Pausable {

    //pausable
    function pause() external onlyOwner {
        _pause();
    }
    function unpause() external onlyOwner {
        _unpause();
    }

    //address
    address public address_Murasaki_Address;
    function _set_Murasaki_Address(address _address) external onlyOwner {
        address_Murasaki_Address = _address;
    }
    
    //Murasaki_Main
    function owner(uint _summoner) public view returns (address) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        return mfs.get_owner(_summoner);
    }
    function class(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Main mm = Murasaki_Main(ma.address_Murasaki_Main());
        return mm.class(_summoner);
    }
    function age(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Main mm = Murasaki_Main(ma.address_Murasaki_Main());
        uint _now = block.timestamp;
        uint _age = _now - mm.summoned_time(_summoner);
        return _age;
    }
    
    //Murasaki_Name
    function name(uint _summoner) public view returns (string memory) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Name mn = Murasaki_Name(ma.address_Murasaki_Name());
        return mn.names(_summoner);
    }
    
    /*
    //Murasaki_Craft
    function balance_of_item(uint _summoner) public view returns (uint[256] memory) {
        address _owner = owner(_summoner);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(murasaki_function_share_address);
        Murasaki_Craft mc = Murasaki_Craft(mfs.murasaki_craft_address());
        return mc.get_balance_of_type(_owner);
    }
    */
    
    //Murasaki_Storage
    function level(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        return ms.level(_summoner);
    }
    function exp(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        return ms.exp(_summoner);
    }
    function strength(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        return ms.strength(_summoner);
    }
    function dexterity(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        return ms.dexterity(_summoner);
    }
    function intelligence(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        return ms.intelligence(_summoner);
    }
    function luck(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        return ms.luck(_summoner);
    }
    function next_exp_required(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        return ms.next_exp_required(_summoner);
    }
    /*
    function last_level_up_time(uint _summoner) external view returns (uint) {
        Murasaki_Function_Share mfs = Murasaki_Function_Share(murasaki_function_share_address);
        Murasaki_Storage ms = Murasaki_Storage(mfs.murasaki_storage_address());
        return ms.last_level_up_time(_summoner);
    }
    */
    function coin(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        return ms.coin(_summoner);
    }
    function material(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        return ms.material(_summoner);
    }
    function last_feeding_time(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        return ms.last_feeding_time(_summoner);
    }
    function last_grooming_time(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        return ms.last_grooming_time(_summoner);
    }
    function working_status(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        return ms.working_status(_summoner);
    }
    /*
    function mining_status(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        return ms.mining_status(_summoner);
    }
    */
    function mining_start_time(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        return ms.mining_start_time(_summoner);
    }
    /*
    function farming_status(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        return ms.farming_status(_summoner);
    }
    */
    function farming_start_time(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        return ms.farming_start_time(_summoner);
    }
    /*
    function crafting_status(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        return ms.crafting_status(_summoner);
    }
    */
    function crafting_start_time(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        return ms.crafting_start_time(_summoner);
    }
    function crafting_item_type(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        return ms.crafting_item_type(_summoner);
    }
    /*
    function total_mining_sec(uint _summoner) public view returns (uint) {
        Murasaki_Function_Share mfs = Murasaki_Function_Share(murasaki_function_share_address);
        Murasaki_Storage ms = Murasaki_Storage(mfs.murasaki_storage_address());
        return ms.total_mining_sec(_summoner);
    }
    function total_farming_sec(uint _summoner) public view returns (uint) {
        Murasaki_Function_Share mfs = Murasaki_Function_Share(murasaki_function_share_address);
        Murasaki_Storage ms = Murasaki_Storage(mfs.murasaki_storage_address());
        return ms.total_farming_sec(_summoner);
    }
    function total_crafting_sec(uint _summoner) public view returns (uint) {
        Murasaki_Function_Share mfs = Murasaki_Function_Share(murasaki_function_share_address);
        Murasaki_Storage ms = Murasaki_Storage(mfs.murasaki_storage_address());
        return ms.total_crafting_sec(_summoner);
    }
    */
    function staking_reward_counter(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        return ms.staking_reward_counter(_summoner);
    }
    /*
    function last_grooming_time_plus_working_time(uint _summoner) external view returns (uint) {
        Murasaki_Function_Share mfs = Murasaki_Function_Share(murasaki_function_share_address);
        Murasaki_Storage ms = Murasaki_Storage(mfs.murasaki_storage_address());
        return ms.last_grooming_time_plus_working_time(_summoner);
    }
    */
    function total_staking_reward_counter(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        return ms.total_staking_reward_counter(_summoner);
    }
    function crafting_resume_flag(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        return ms.crafting_resume_flag(_summoner);
    }
    function crafting_resume_item_type(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        return ms.crafting_resume_item_type(_summoner);
    }
    function crafting_resume_item_dc(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        return ms.crafting_resume_item_dc(_summoner);
    }

    //Murasaki_Storage_Score
    function total_exp_gained(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage_Score mss = Murasaki_Storage_Score(ma.address_Murasaki_Storage_Score());
        return mss.total_exp_gained(_summoner);
    }
    function total_coin_mined(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage_Score mss = Murasaki_Storage_Score(ma.address_Murasaki_Storage_Score());
        return mss.total_coin_mined(_summoner);
    }
    function total_material_farmed(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage_Score mss = Murasaki_Storage_Score(ma.address_Murasaki_Storage_Score());
        return mss.total_material_farmed(_summoner);
    }
    function total_item_crafted(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage_Score mss = Murasaki_Storage_Score(ma.address_Murasaki_Storage_Score());
        return mss.total_item_crafted(_summoner);
    }
    function total_precious_received(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage_Score mss = Murasaki_Storage_Score(ma.address_Murasaki_Storage_Score());
        return mss.total_precious_received(_summoner);
    }
    function total_feeding_count(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage_Score mss = Murasaki_Storage_Score(ma.address_Murasaki_Storage_Score());
        return mss.total_feeding_count(_summoner);
    }
    function total_grooming_count(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage_Score mss = Murasaki_Storage_Score(ma.address_Murasaki_Storage_Score());
        return mss.total_grooming_count(_summoner);
    }
    function total_neglect_count(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage_Score mss = Murasaki_Storage_Score(ma.address_Murasaki_Storage_Score());
        return mss.total_neglect_count(_summoner);
    }
    function total_critical_count(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage_Score mss = Murasaki_Storage_Score(ma.address_Murasaki_Storage_Score());
        return mss.total_critical_count(_summoner);
    }
    
    //Function_Share
    function satiety(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        return mfs.calc_satiety(_summoner);
    }
    function happy(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        return mfs.calc_happy(_summoner);
    }
    function precious(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        return mfs.calc_precious(_summoner);
    }
    function not_petrified(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        bool _res = mfs.not_petrified(_summoner);
        if (_res == true) {
            return uint(1);
        } else {
            return uint(0);
        }
    }
    function dapps_staking_amount(uint _summoner) public view returns (uint) {
        address _owner = owner(_summoner);
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        return mfs.calc_dapps_staking_amount(_owner);
    }
    function score(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        return mfs.calc_score(_summoner);
    }
    function get_speed_of_dappsStaking(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        return mfs.get_speed_of_dappsStaking(_summoner);
    }
    function calc_exp_addition_rate_from_twinkle(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        return mfs.calc_exp_addition_rate_from_twinkle(_summoner);
    }
    
    //Function_Working
    function calc_mining(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Mining_and_Farming mfmf = Murasaki_Function_Mining_and_Farming(ma.address_Murasaki_Function_Mining_and_Farming());
        return mfmf.calc_mining(_summoner);
    }
    function calc_farming(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Mining_and_Farming mfmf = Murasaki_Function_Mining_and_Farming(ma.address_Murasaki_Function_Mining_and_Farming());
        return mfmf.calc_farming(_summoner);
    }
    function calc_crafting(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Crafting mfc = Murasaki_Function_Crafting(ma.address_Murasaki_Function_Crafting());
        return mfc.calc_crafting(_summoner);
    }
    function strength_withItems(uint _summoner) public view returns (uint) {
        address _owner = owner(_summoner);
        uint _str = strength(_summoner);
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Mining_and_Farming mfmf = Murasaki_Function_Mining_and_Farming(ma.address_Murasaki_Function_Mining_and_Farming());
        _str += mfmf.count_mining_items(_owner);
        return _str;
    }
    function dexterity_withItems(uint _summoner) public view returns (uint) {
        address _owner = owner(_summoner);
        uint _dex = dexterity(_summoner);
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Mining_and_Farming mfmf = Murasaki_Function_Mining_and_Farming(ma.address_Murasaki_Function_Mining_and_Farming());
        _dex += mfmf.count_farming_items(_owner);
        return _dex;
    }
    function intelligence_withItems(uint _summoner) public view returns (uint) {
        address _owner = owner(_summoner);
        uint _int = intelligence(_summoner);
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Crafting mfc = Murasaki_Function_Crafting(ma.address_Murasaki_Function_Crafting());
        _int += mfc.count_crafting_items(_owner);
        return _int;
    }
    function luck_withItems(uint _summoner) public view returns (uint) {
        uint _luk = luck(_summoner);
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        _luk += mfs.calc_precious(_summoner);
        return _luk;
    }
    /*
    function luck_withItems_withStaking(uint _summoner) public view returns (uint) {
        uint _luk = luck_withItems(_summoner);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(murasaki_function_share_address);
        _luk += mfs.get_luck_by_staking(_summoner);
        return _luk;
    }
    */
    function calc_feeding(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Feeding_and_Grooming mffg = Murasaki_Function_Feeding_and_Grooming(ma.address_Murasaki_Function_Feeding_and_Grooming());
        return mffg.calc_feeding(_summoner);
    }
    function calc_grooming(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Feeding_and_Grooming mffg = Murasaki_Function_Feeding_and_Grooming(ma.address_Murasaki_Function_Feeding_and_Grooming());
        return mffg.calc_grooming(_summoner);
    }
    
    //Dice
    function last_rolled_dice(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Dice md = Murasaki_Dice(ma.address_Murasaki_Dice());
        return md.get_last_rolled_dice(_summoner);
    }
    function last_dice_roll_time(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Dice md = Murasaki_Dice(ma.address_Murasaki_Dice());
        return md.last_dice_roll_time(_summoner);
    }
    function luck_withItems_withDice(uint _summoner) public view returns (uint) {
        uint _luk = luck_withItems(_summoner);
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Dice md = Murasaki_Dice(ma.address_Murasaki_Dice());
        _luk += md.get_rolled_dice(_summoner);
        return _luk;
    }
    
    //Mail
    function receiving_mail(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Mail mml = Murasaki_Mail(ma.address_Murasaki_Mail());
        bool _res = mml.check_receiving_mail(_summoner);
        if (_res == true) {
            return uint(1);
        } else {
            return uint(0);
        }
    }
    function sending_interval(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Mail mml = Murasaki_Mail(ma.address_Murasaki_Mail());
        return mml.calc_sending_interval(_summoner);
    }
    function check_lastMailOpen(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Mail mml = Murasaki_Mail(ma.address_Murasaki_Mail());
        bool _res = mml.check_lastMailOpen(_summoner);
        if (_res == true) {
            return uint(1);
        } else {
            return uint(0);
        }
    }
    
    //Lootlike
    function allStatus(uint _summoner) public view returns (string[8] memory) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Lootlike mll = Murasaki_Lootlike(ma.address_Murasaki_Lootlike());
        return mll.get_allStatus(_summoner);
    }
    
    //isActive
    function isActive(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        bool _isActive = ms.isActive(_summoner);
        if (_isActive == true) {
            return uint(1);
        } else {
            return uint(0);
        }
    }
    
    //inHouse
    function inHouse(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        bool _inHouse = ms.inHouse(_summoner);
        if (_inHouse == true) {
            return uint(1);
        } else {
            return uint(0);
        }
    }
    
    function next_festival_block() public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Fluffy_Festival ff = Fluffy_Festival(ma.address_Fluffy_Festival());
        return ff.next_festival_block();
    }
    
    //parameter
    function speed() public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        return mp.SPEED();
    }
    function price() public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        return mp.PRICE();
    }
    function staking_reward_sec() public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        return mp.STAKING_REWARD_SEC();
    }
    function elected_fluffy_type() public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        return mp.ELECTED_FLUFFY_TYPE();
    }
    function isTrial() public view returns (bool) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        return mp.isTrial();
    }
    
    //Achievement_onChain
    function get_score(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Achievement_onChain ac = Achievement_onChain(ma.address_Achievement_onChain());
        return ac.get_score(_summoner);
    }
    function get_score_token(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Achievement_onChain ac = Achievement_onChain(ma.address_Achievement_onChain());
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        address _owner = mfs.get_owner(_summoner);
        return ac.get_score_token(_owner);
    }
    function get_score_nft(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Achievement_onChain ac = Achievement_onChain(ma.address_Achievement_onChain());
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        address _owner = mfs.get_owner(_summoner);
        return ac.get_score_nft(_owner);
    }
    function get_score_staking(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Achievement_onChain ac = Achievement_onChain(ma.address_Achievement_onChain());
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        address _owner = mfs.get_owner(_summoner);
        return ac.get_score_staking(_owner);
    }
    function get_score_murasaki_nft(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Achievement_onChain ac = Achievement_onChain(ma.address_Achievement_onChain());
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        address _owner = mfs.get_owner(_summoner);
        return ac.get_score_murasaki_nft(_owner);
    }
    
    //Practice
    function exp_clarinet (uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        return ms.exp_clarinet(_summoner);
    }
    function exp_piano (uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        return ms.exp_piano(_summoner);
    }
    function exp_violin (uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        return ms.exp_violin(_summoner);
    }
    function exp_horn (uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        return ms.exp_horn(_summoner);
    }
    function exp_timpani (uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        return ms.exp_timpani(_summoner);
    }
    function exp_harp (uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        return ms.exp_harp(_summoner);
    }
    /*
    function practice_status (uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        return ms.practice_status(_summoner);
    }
    */
    function practice_item_id (uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        return ms.practice_item_id(_summoner);
    }
    function practice_start_time (uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        return ms.practice_start_time(_summoner);
    }
    function get_practiceLevel_clarinet (uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Music_Practice mfp = Murasaki_Function_Music_Practice(ma.address_Murasaki_Function_Music_Practice());
        return mfp.get_practiceLevel_clarinet(_summoner);
    }
    function get_practiceLevel_piano (uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Music_Practice mfp = Murasaki_Function_Music_Practice(ma.address_Murasaki_Function_Music_Practice());
        return mfp.get_practiceLevel_piano(_summoner);
    }
    function get_practiceLevel_violin (uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Music_Practice mfp = Murasaki_Function_Music_Practice(ma.address_Murasaki_Function_Music_Practice());
        return mfp.get_practiceLevel_violin(_summoner);
    }
    function get_practiceLevel_horn (uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Music_Practice mfp = Murasaki_Function_Music_Practice(ma.address_Murasaki_Function_Music_Practice());
        return mfp.get_practiceLevel_horn(_summoner);
    }
    function get_practiceLevel_timpani (uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Music_Practice mfp = Murasaki_Function_Music_Practice(ma.address_Murasaki_Function_Music_Practice());
        return mfp.get_practiceLevel_timpani(_summoner);
    }
    function get_practiceLevel_harp (uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Music_Practice mfp = Murasaki_Function_Music_Practice(ma.address_Murasaki_Function_Music_Practice());
        return mfp.get_practiceLevel_harp(_summoner);
    }
    
    //staking
    function get_staking_percent(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Staking_Reward mfsl = Murasaki_Function_Staking_Reward(ma.address_Murasaki_Function_Staking_Reward());
        return mfsl.get_staking_percent(_summoner);
    }
    
    //stroll
    function total_strolledDistance(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Stroll s = Stroll(ma.address_Stroll());
        return s.total_strolledDistance(_summoner);
    }
    function total_metSummoners(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Stroll s = Stroll(ma.address_Stroll());
        return s.total_metSummoners(_summoner);
    }
    function strolling_remining_sec(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Stroll s = Stroll(ma.address_Stroll());
        return s.get_reminingSec(_summoner);
    }
    
    //pippel
    function check_pippel(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Pippel_Function pf = Pippel_Function(ma.address_Pippel_Function());
        bool _pippelAppear = pf.check_pippel(_summoner);
        if (_pippelAppear == true) {
            return uint(1);
        } else {
            return uint(0);
        }        
    }
    function pippel_score(uint _summoner) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Pippel_Function pf = Pippel_Function(ma.address_Pippel_Function());
        return pf.calc_pippelScore(_summoner);
    }
    
    
    //### dynamic
    function allDynamicStatus(uint _summoner) external view whenNotPaused returns (uint[96] memory) {
        uint[96] memory _res;
        _res[0] = block.number;
        _res[1] = age(_summoner);
        _res[2] = level(_summoner);
        _res[3] = exp(_summoner);
        _res[4] = strength(_summoner);
        _res[5] = dexterity(_summoner);
        _res[6] = intelligence(_summoner);
        _res[7] = luck(_summoner);
        _res[8] = next_exp_required(_summoner);
        _res[9] = coin(_summoner);
        _res[10] = material(_summoner);
        _res[11] = last_feeding_time(_summoner);
        _res[12] = last_grooming_time(_summoner);
        //_res[13] = mining_status(_summoner);
        _res[14] = mining_start_time(_summoner);
        //_res[15] = farming_status(_summoner);
        _res[16] = farming_start_time(_summoner);
        //_res[17] = crafting_status(_summoner);
        _res[18] = crafting_start_time(_summoner);
        _res[19] = crafting_item_type(_summoner);
        //_res[20] = total_mining_sec(_summoner);
        //_res[21] = total_farming_sec(_summoner);
        //_res[22] = total_crafting_sec(_summoner);
        _res[23] = total_exp_gained(_summoner);
        _res[24] = total_coin_mined(_summoner);
        _res[25] = total_material_farmed(_summoner);
        _res[26] = total_item_crafted(_summoner);
        _res[27] = total_precious_received(_summoner);
        _res[28] = satiety(_summoner);
        _res[29] = happy(_summoner);
        _res[30] = precious(_summoner);
        _res[31] = not_petrified(_summoner);
        _res[32] = dapps_staking_amount(_summoner);
        //_res[33] = luck_by_staking(_summoner);
        _res[34] = score(_summoner);
        _res[35] = strength_withItems(_summoner);
        _res[36] = dexterity_withItems(_summoner);
        _res[37] = intelligence_withItems(_summoner);
        _res[38] = luck_withItems(_summoner);
        //_res[39] = luck_withItems_withStaking(_summoner);
        _res[40] = last_rolled_dice(_summoner);
        _res[41] = last_dice_roll_time(_summoner);
        //_res[42] = luck_withItems_withStaking_withDice(_summoner);
        _res[42] = luck_withItems_withDice(_summoner);
        _res[43] = receiving_mail(_summoner);
        _res[44] = sending_interval(_summoner);
        _res[45] = isActive(_summoner);
        _res[46] = calc_mining(_summoner);
        _res[47] = calc_farming(_summoner);
        _res[48] = calc_crafting(_summoner);
        _res[49] = inHouse(_summoner);
        _res[50] = check_lastMailOpen(_summoner);
        //_res[51] = luck_challenge_of_mffg(_summoner);
        //_res[52] = luck_challenge_of_mfmf(_summoner);
        //_res[53] = luck_challenge_of_mfc(_summoner);
        _res[54] = calc_feeding(_summoner);
        _res[55] = calc_grooming(_summoner);
        _res[56] = staking_reward_counter(_summoner);
        //_res[57] = check_votable(_summoner);
        _res[58] = get_speed_of_dappsStaking(_summoner);
        _res[59] = total_staking_reward_counter(_summoner);
        _res[60] = next_festival_block();
        _res[61] = crafting_resume_flag(_summoner);
        _res[62] = crafting_resume_item_type(_summoner);
        _res[63] = crafting_resume_item_dc(_summoner);
        _res[64] = get_score(_summoner);
        _res[65] = get_score_token(_summoner);
        _res[66] = get_score_nft(_summoner);
        _res[67] = get_score_staking(_summoner);
        _res[68] = get_score_murasaki_nft(_summoner);
        _res[69] = exp_clarinet(_summoner);
        _res[70] = exp_piano(_summoner);
        _res[71] = exp_violin(_summoner);
        _res[72] = exp_horn(_summoner);
        _res[73] = exp_timpani(_summoner);
        _res[74] = exp_harp(_summoner);
        //_res[75] = practice_status(_summoner);
        _res[76] = practice_item_id(_summoner);
        _res[77] = practice_start_time(_summoner);
        _res[78] = get_practiceLevel_clarinet(_summoner);
        _res[79] = get_practiceLevel_piano(_summoner);
        _res[80] = get_practiceLevel_violin(_summoner);
        //_res[81] = get_practiceLevel_horn(_summoner);
        //_res[82] = get_practiceLevel_timpani(_summoner);
        //_res[83] = get_practiceLevel_harp(_summoner);
        _res[84] = get_staking_percent(_summoner);
        _res[85] = calc_exp_addition_rate_from_twinkle(_summoner);
        _res[86] = working_status(_summoner);
        _res[87] = total_strolledDistance(_summoner);
        _res[88] = total_metSummoners(_summoner);
        _res[89] = total_feeding_count(_summoner);
        _res[90] = total_grooming_count(_summoner);
        _res[91] = total_neglect_count(_summoner);
        _res[92] = total_critical_count(_summoner);
        _res[93] = strolling_remining_sec(_summoner);
        _res[94] = check_pippel(_summoner);
        _res[95] = pippel_score(_summoner);
        return _res;
    }
    
    //### static
    function allStaticStatus(uint _summoner) external view whenNotPaused returns (
        uint,
        address,
        string memory,
        string[8] memory,
        uint,
        uint,
        uint,
        uint,
        bool
    ) {
        uint _class = class(_summoner);
        address _owner = owner(_summoner);
        string memory _name = name(_summoner);
        string[8] memory lootStatus = allStatus(_summoner);
        return (
            _class, //0
            _owner, //1
            _name, //2
            lootStatus, //3
            speed(),    //4
            price(),    //5
            staking_reward_sec(),   //6
            elected_fluffy_type(),  //7
            isTrial()   //8
        );
    }

    //item
    function allItemBalance(uint _summoner) public view returns (uint[320] memory) {
        address _owner = owner(_summoner);
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Craft mc = Murasaki_Craft(ma.address_Murasaki_Craft());
        return mc.get_balance_of_type(_owner);
    }
    
    function allItemId_withItemType(uint _summoner) public view returns (uint[] memory) {
        address _owner = owner(_summoner);
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Craft mc = Murasaki_Craft(ma.address_Murasaki_Craft());
        uint _myListLength = mc.myListLength(_owner);
        return mc.myListsAt_withItemType(_owner, 0, _myListLength);
    }
}


//---Murasaki_Lootlike

contract Murasaki_Lootlike is Ownable, Pausable {

    //pausable
    function pause() external onlyOwner {
        _pause();
    }
    function unpause() external onlyOwner {
        _unpause();
    }

    //address
    address public address_Murasaki_Address;
    function _set_Murasaki_Address(address _address) external onlyOwner {
        address_Murasaki_Address = _address;
    }
    
    function get_birthplace(uint _summoner) public view returns (string memory) {
        return pluckName(_summoner, "birthplace", birthplace);
    }
    function get_personality(uint _summoner) public view returns (string memory) {
        return pluckName(_summoner, "personality", personality);
    }
    function get_character(uint _summoner) public view returns (string memory) {
        return pluckName(_summoner, "character", character);
    }
    function get_weakpoint(uint _summoner) public view returns (string memory) {
        return pluckName(_summoner, "weakpoint", weakpoint);
    }
    function get_scent(uint _summoner) public view returns (string memory) {
        return pluckName(_summoner, "scent", scent);
    }
    function get_flower(uint _summoner) public view returns (string memory) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Main mm = Murasaki_Main(ma.address_Murasaki_Main());
        uint _class = mm.class(_summoner);
        return flower[_class];
    }
    function get_street(uint _summoner) public view returns (string memory) {
        return pluckName(_summoner, "street", street);
    }
    function get_city(uint _summoner) public view returns (string memory) {
        return pluckName(_summoner, "city", city);
    }
    function get_allStatus(uint _summoner) public view whenNotPaused returns (string[8] memory) {
        string[8] memory _status;
        _status[0] = get_birthplace(_summoner);
        _status[1] = get_personality(_summoner);
        _status[2] = get_character(_summoner);
        _status[3] = get_weakpoint(_summoner);
        _status[4] = get_scent(_summoner);
        _status[5] = get_flower(_summoner);        
        _status[6] = get_street(_summoner);        
        _status[7] = get_city(_summoner);        
        return _status;
    }

    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
    
    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function pluckName(uint _summoner, string memory keyPrefix, string[] memory sourceArray) internal view returns (string memory) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        address _owner = mfs.get_owner(_summoner);
        uint256 rand = random(
            string(
                abi.encodePacked(
                    keyPrefix,
                    _owner
                )
            )
        );
        string memory output = sourceArray[rand % sourceArray.length];
        return output;
    }

    string[] private birthplace = [
        "Fluffy Sweater",
        "Fluffy Blanket",
        "Fluffy Carpet",
        "Fluffy Cushion",
        "Fluffy Scarf",
        "Fluffy Sofa"
    ];
    
    string[] private character = [
        "Diligent",
        "Optimist",
        "Realist",
        "Ethical",
        "Sensitive",
        "Adventurous",
        "Compassionate",
        "Empathetic",
        "Patient",
        "Courageous",
        "Honest"
    ];
    
    string[] private weakpoint = [
        "a bit Moody",
        "a bit Lonely",
        "a bit Sleeper",
        "a bit Nervous",
        "a bit Competitive",
        "a bit Obstinate",
        "a bit Forgetful",
        "a bit Perfectionist",
        "a bit Shy",
        "a bit Tomboy"
    ];

    string[] private scent = [
        "Floral",
        "Refreshing",
        "Gentle",
        "Mild",
        "Fruity",
        "Sunshine",
        "Sweet",
        "Soft",
        "Exotic"
    ];
    
    string[] private personality = [
        "Friendly",
        "Reliable",
        "Frisky",
        "Thoughtful",
        "Easygoing",
        "Tolerant",
        "Affectionate",
        "Intelligent",
        "Faithful",
        "Innocent",
        "Gentle",              
        "Cheerful"
    ];
    
    string[] private flower = [
        "Rose",
        "Marigold",
        "Dandelion",
        "Rosemary",
        "Olive",
        "Holly",
        "Nemophila",
        "Hydrangea",
        "Forget-me-not",
        "Sumire",
        "Gerbera",
        "Anemone"
    ];
    
    string[] private city = [
        "Garnet City",
        "Amethyst City",
        "Aquamarine City",
        "Diamond City",
        "Emerald City",
        "Pearl City",
        "Ruby Town",
        "Peridot Town",
        "Sapphire Town",
        "Opal Town",
        "Topaz Town",
        "Turquoise Town"
    ];

    string[] private street = [
        "Apple Ave.",
        "Strawberry Ave.",
        "Avocado Ave.",
        "Orange Ave.",
        "Raspberry Ave.",
        "Kiwi Ave.",
        "Grapefrit Ave.",
        "Coconut Ave.",
        "Cherry Ave.",
        "Pineapple Ave.",
        "Banana Ave.",
        "Grape Ave.",
        "Blueberry Ave.",
        "Muskmelon Ave.",
        "Mango Ave.",
        "Peach Ave.",
        "Yuzu Ave.",
        "Lemon Ave.",
        "Lime Ave.",
        "Pumpkin St.",
        "Cabbage St.",
        "Cucumber St.",
        "Sesami St.",
        "Potato St.",
        "Ginger St.",
        "Leek St.",
        "Soybean St.",
        "Onion St.",
        "Tomato St.",
        "Carrot St.",
        "Garlic St.",
        "Basil St.",
        "Paprika St.",
        "Broccoli St.",
        "Lotus St.",
        "Califlower St.",
        "Bamboo St.",
        "Eggplant St."
    ];
}


//---Murasaki_tokenURI

contract Murasaki_tokenURI is Ownable, Pausable {

    //pausable
    function pause() external onlyOwner {
        _pause();
    }
    function unpause() external onlyOwner {
        _unpause();
    }

    //address
    address public address_Murasaki_Address;
    function _set_Murasaki_Address(address _address) external onlyOwner {
        address_Murasaki_Address = _address;
    }

    string[] private color = [
        "#E60012",
        "#F39800",
        "#FFF100",
        "#8FC31F",
        "#009944",
        "#009E96",
        "#00A0E9",
        "#0068B7",
        "#1D2088",
        "#920783",
        "#E4007F",
        "#E5004F"
    ];

    string[] private flower = [
        "Rose",
        "Marigold",
        "Dandelion",
        "Rosemary",
        "Olive",
        "Holly",
        "Nemophila",
        "Hydrangea",
        "Forget-me-not",
        "Sumire",
        "Gerbera",
        "Anemone"
    ];

    function toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
    
    function _balanceOfItems(uint _summoner) internal view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Craft mc = Murasaki_Craft(ma.address_Murasaki_Craft());
        if (_summoner == 0) {
            return 0;
        }
        return mc.balanceOf(mfs.get_owner(_summoner));
    }
    
    function _get_endSVG(uint _summoner) internal view returns (string memory) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Storage ms = Murasaki_Storage(ma.address_Murasaki_Storage());
        if (_summoner == 0) {
            //token not found
            return '<rect width="128" height="128" fill="#ffffff" rx="10" ry="10" fill-opacity="0.8"/><text x="64"  y="60" class="base" text-anchor="middle">Token</text><text x="64"  y="80" class="base" text-anchor="middle">Not Found</text></svg>';
        } else if (mp.isTrial()) {
            //trial
            return '<rect width="128" height="128" fill="#ffffff" rx="10" ry="10" fill-opacity="0.8"/><text x="64"  y="60" class="base" text-anchor="middle">Trial</text><text x="64"  y="82" class="base" text-anchor="middle">Token</text></svg>';
        } else if (!mfs.not_petrified(_summoner)) {
            //petrified
            return '<rect width="128" height="128" fill="#ffffff" rx="10" ry="10" fill-opacity="0.8"/><text x="64"  y="60" class="base" text-anchor="middle">Petrified</text><text x="64"  y="82" class="base" text-anchor="middle">Token</text></svg>';
        } else if (!ms.isActive(_summoner)) {
            //petrified
            return '<rect width="128" height="128" fill="#ffffff" rx="10" ry="10" fill-opacity="0.8"/><text x="64"  y="60" class="base" text-anchor="middle">Not Active</text><text x="64"  y="82" class="base" text-anchor="middle">Token</text></svg>';
        } else {
            return '</svg>';
        }
    }
    
    function ownerOf(uint _token) public view returns (address) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        return mfs.get_owner(_token);
    }
        
    function _get_SVG(uint _summoner) internal view returns (string memory) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Info mi = Murasaki_Info(ma.address_Murasaki_Info());
        //string memory output = string(abi.encodePacked(
        return string(
            bytes.concat(
                abi.encodePacked(
                    '<svg width="64" height="64" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 128 128"><style>.base { fill: #000000; font-family: arial; font-size: 18px; font-weight: bold}</style><rect width="128" height="128" fill="',
                    string(abi.encodePacked(color[mi.class(_summoner)])),
                    '" rx="10" ry="10" fill-opacity="0.4"/><image width="128" height="128" x="0" y="0" href="data:image/png;base64,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"/><text x="3"  y="18"  class="base" text-anchor="start">#',
                    string(abi.encodePacked(toString(_summoner))),
                    '</text><text x="124" y="22"  class="base" text-anchor="end">Lv<tspan font-size="24px">',
                    string(abi.encodePacked(toString(mi.level(_summoner))))
                ),
                abi.encodePacked(
                    '</tspan></text><text x="64"  y="92" class="base" text-anchor="middle"><tspan font-size="20px">',
                    string(abi.encodePacked(mi.name(_summoner))),
                    '</tspan></text><text x="124" y="122" class="base" text-anchor="end">&#x1f4bc;',
                    
                    //detailed
                    string(abi.encodePacked(toString(_balanceOfItems(_summoner)))),
                    '</text><text x="124" y="38" class="base" text-anchor="end"><tspan font-size="14">&#x1f359;',
                    string(abi.encodePacked(toString(mi.satiety(_summoner)))),
                    '</tspan></text><text x="4" y="124" class="base" text-anchor="start"><tspan font-size="14" fill="black">',
                    string(abi.encodePacked(toString(mi.score(_summoner)))),
                    '</tspan></text>',

                    /*
                    //simple
                    '</tspan></text><text x="124" y="122" class="base" text-anchor="end">&#x1f4bc;',
                    string(abi.encodePacked(toString(_balanceOfItems(_summoner)))),
                    */

                    _get_endSVG(_summoner)
                )
            )
        );
    }
    
    function tokenURI(uint _summoner) public view whenNotPaused returns (string memory) {
        string memory output = _get_SVG(_summoner);
        string memory json = Base64.encode(bytes(string(abi.encodePacked(
            '{"name": "Murasaki-san #', 
            toString(_summoner), 
            '", "description": "House of Murasaki-san. Murasaki-san is a pet living in your wallet on Astar Network. https://murasaki-san.com/", "image": "data:image/svg+xml;base64,', 
            Base64.encode(bytes(output)), '"}'
        ))));
        return string(abi.encodePacked('data:application/json;base64,', json));
    }
    
    function tokenURI_fromWallet(address _wallet) public view returns (string memory) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Main mm = Murasaki_Main(ma.address_Murasaki_Main());
        uint _summoner = mm.tokenOf(_wallet);
        return tokenURI(_summoner);
    }
    
    //mimic ERC165
    function supportsInterface(bytes4 interfaceId) public pure returns (bool) {
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId;
    }
    
    //mimic ERC721Metadata
    function name() external view returns (string memory) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Main mm = Murasaki_Main(ma.address_Murasaki_Main());
        string memory _res = mm.name();
        return _res;
    }
    function symbol() external view returns (string memory) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Main mm = Murasaki_Main(ma.address_Murasaki_Main());
        string memory _res = mm.symbol();
        return _res;
    }
}


//===Treasury======================================================================================================


//---BufferVault

//trading fee, dapps staking reward, other fees
contract BufferVault is Ownable, ReentrancyGuard, Pausable {

    //pausable
    function pause() external onlyOwner {
        _pause();
    }
    function unpause() external onlyOwner {
        _unpause();
    }

    //receivable
    receive() external payable {
    }
    fallback() external payable {
    }
    
    //variable
    uint public last_transfer_time;
    
    //address
    address public address_Murasaki_Address;
    function _set_Murasaki_Address(address _address) external onlyOwner {
        address_Murasaki_Address = _address;
    }
    
    //admin, set inflation rate
    uint public inflationRate = 300;    //300 = 3%
    function set_inflationRate(uint _value) external onlyOwner {
        inflationRate = _value;
    }

    //admin, set developer reword rate
    uint public developerRewardRate = 1000;    //1000 = 10%
    function set_developerRewardRate(uint _value) external onlyOwner {
        developerRewardRate = _value;
    }

    //admin, set transfer interval
    uint public transferInterval = 86400 * 25;    //sec, 25 days
    function set_transferInterval(uint _value) external onlyOwner {
        transferInterval = _value;
    }

    //admin. withdraw all, for emergency
    function withdraw(address rec)public onlyOwner{
        payable(rec).transfer(address(this).balance);
    }
    
    //calc amount needed and reflex flag
    function calc_amountNeeded_forTransfer() public view returns (uint, bool) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Main mm = Murasaki_Main(ma.address_Murasaki_Main());
        BuybackTreasury bbt = BuybackTreasury(payable(ma.address_BuybackTreasury()));
        uint _allSummoners = mm.next_token() - 1;
        uint _disabledSummoners = bbt.disabledSummoners();
        uint _activeSummoners = _allSummoners - _disabledSummoners;
        uint _amountPerSummoner = bbt.amountPerSummoner();
        uint _amount_inTreasury = ma.address_BuybackTreasury().balance;
        //uint _amountPaied_total = bbt.amountPaied_total();
        uint _amountNeeded_inTreasury = 
            _activeSummoners * _amountPerSummoner * (10000 + inflationRate)/10000;
        bool _reflex;
        uint _amountNeeded_forTransfer;
        if (_amountNeeded_inTreasury >= _amount_inTreasury) {
            _amountNeeded_forTransfer = _amountNeeded_inTreasury - _amount_inTreasury;
        } else {
            _reflex = true;
            _amountNeeded_forTransfer = _amount_inTreasury - _amountNeeded_inTreasury;            
        }
        return (_amountNeeded_forTransfer, _reflex);
    }
    
    //check transferable
    //amount in vault >= IR3% + dev reward, or flag_reflex = true
    function check_transferable() public view returns (bool) {
        //check last transfer >30 days
        if (block.timestamp - last_transfer_time <= transferInterval) {
            return false;
        }
        //check reflex > 0
        (uint _amountNeeded_forTransfer, bool _reflex) = calc_amountNeeded_forTransfer();
        if (_reflex) {
            return true;
        }
        //chekc: amount_inVault >= amountNeeded + 20%(10%:devReward, 10%:Staking)
        uint _amount_inVault = address(this).balance;
        if (_amount_inVault >= _amountNeeded_forTransfer * 120/100) {
            return true;
        }
        return false;
    }
    
    // admin, transfer tokens
    function transfer_for_buybackTreasury() external nonReentrant onlyOwner whenNotPaused {
        _transfer_for_buybackTreasury();
    }
    // internal
    event TransferForBuybackTreasury (
        address indexed _wallet, uint _devReward, bool _reflex, uint _amountNeeded_forTransfer, uint _forStaking);
    function _transfer_for_buybackTreasury() internal {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        BuybackTreasury bbt = BuybackTreasury(payable(ma.address_BuybackTreasury()));
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        require(check_transferable());
        // 10%: transfer to developer reward
        uint _devReward = address(this).balance * developerRewardRate/10000 /2;
        payable(ma.address_Coder_Wallet()).transfer(_devReward);
        payable(ma.address_Illustrator_Wallet()).transfer(_devReward);
        // amountNeeded: transfer to/from buybackTreasury
        (uint _amountNeeded_forTransfer, bool _reflex) = calc_amountNeeded_forTransfer();
        if (_reflex) {
            bbt.reflex_to_bufferVault(_amountNeeded_forTransfer);
        } else {
            payable(ma.address_BuybackTreasury()).transfer(_amountNeeded_forTransfer);
        }
        // all the rest: transfer to staking wallet
        uint _forStaking = address(this).balance;
        //payable(ma.address_Staking_Wallet()).transfer(address(this).balance);
        payable(ma.address_Staking_Wallet()).transfer(_forStaking);
        // inflate amountPerSummoner
        uint _amountPerSummoner = bbt.amountPerSummoner();
        bbt.set_amountPerSummoner(_amountPerSummoner * (10000 + inflationRate) / 10000);
        // inflate summon price
        uint _price = mp.PRICE();
        mp._set_price(_price * (10000 + inflationRate) / 10000);
        // update timestamp
        last_transfer_time = block.timestamp;
        emit TransferForBuybackTreasury(msg.sender, _devReward, _reflex, _amountNeeded_forTransfer, _forStaking);
    }
    
    // For future sustainability, make transfers executable by anyone.
    bool public transferableByAnyone;
    function set_transferableByAnyone (bool _value) external onlyOwner {
        transferableByAnyone = _value;
    }
    function transfer_for_buybackTreasury_byPlayer () external nonReentrant whenNotPaused {
        require(transferableByAnyone);
        _transfer_for_buybackTreasury();
    }
}


//---BuybackTreasury

//for buyback items
contract BuybackTreasury is Ownable, ReentrancyGuard, Pausable {

    //pausable
    function pause() external onlyOwner {
        _pause();
    }
    function unpause() external onlyOwner {
        _unpause();
    }

    //*approve of mc is needed

    //token receivable
    receive() external payable {
    }
    fallback() external payable {
    }

    //ERC721Holder
    function onERC721Received(
        address,
        address,
        uint256,
        bytes memory
    ) public pure returns (bytes4) {
        return this.onERC721Received.selector;
    }

    //variants
    //bool public isPaused;
    uint public amountPaied_total = 0;
    uint public disabledSummoners = 0;
    uint public amountPerSummoner = 225 * 10**18;
    mapping(uint => uint) public amountPaied;

    //admin, withdraw all, for emergency
    function withdraw(address rec) public onlyOwner{
        payable(rec).transfer(address(this).balance);
    }
    
    //admin, address
    address public address_Murasaki_Address;
    function _set_Murasaki_Address(address _address) external onlyOwner {
        address_Murasaki_Address = _address;
    }

    //admin, update notActivated summoner number by manually
    function set_disabledSummoners(uint _value) external onlyOwner {
        disabledSummoners = _value;
    }

    //admin, set amount_per_summoner
    function set_amountPerSummoner_byAdmin(uint _value) external onlyOwner {
        amountPerSummoner = _value;
    }

    //admin, reflex, transfer to bufferVault
    function reflex_to_bufferVault_byAdmin(uint _value) external onlyOwner {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        //require(msg.sender == ma.address_BufferVault());
        payable(ma.address_BufferVault()).transfer(_value);
    }

    //admin, set amountPaied
    function set_amountPaied (uint _summoner, uint _value) external onlyOwner {
        amountPaied[_summoner] = _value;
    }
    
    //onlyPermitted, set amount_per_summoner
    function set_amountPerSummoner(uint _value) external {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        require(msg.sender == ma.address_BufferVault());
        amountPerSummoner = _value;
    }
    
    //onlyPermitted, reflex, transfer to bufferVault, only from bufferVault
    function reflex_to_bufferVault(uint _value) external {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        require(msg.sender == ma.address_BufferVault());
        payable(ma.address_BufferVault()).transfer(_value);
    }
    
    function _calc_itemPrice_fromLevel(uint _item_level) internal view returns (uint) {
        uint _coefficient = 0;
        if (_item_level == 1) {
            _coefficient = 93;
        } else if (_item_level == 2) {
            _coefficient = 372;
        } else if (_item_level == 3) {
            _coefficient = 931;
        } else if (_item_level == 4) {
            _coefficient = 1396;
        } else if (_item_level == 5) {
            _coefficient = 1954;
        } else if (_item_level == 6) {
            _coefficient = 2606;
        } else if (_item_level == 7) {
            _coefficient = 3350;
        } else if (_item_level == 8) {
            _coefficient = 4188;
        } else if (_item_level == 9) {
            _coefficient = 5118;
        } else if (_item_level == 10) {
            _coefficient = 6142;
        } else if (_item_level == 11) {
            _coefficient = 7259;
        } else if (_item_level == 12) {
            _coefficient = 8469;
        } else if (_item_level == 13) {
            _coefficient = 9771;
        } else if (_item_level == 14) {
            _coefficient = 11167;
        } else if (_item_level == 15) {
            _coefficient = 12656;
        } else if (_item_level == 16) {
            _coefficient = 14238;
        } else if (_item_level == 21) { //fluffy
            _coefficient = 93;
        } else if (_item_level == 22) { //fluffier
            _coefficient = 512;
        } else if (_item_level == 23) { //fluffiest
            _coefficient = 2252;
        } else if (_item_level == 24) { //doll
            _coefficient = 7432;
        }
        uint _price = amountPerSummoner * _coefficient / 100000;
        return _price;
    }
    
    function calc_buybackPrice_from_itemType(uint _item_type) public view returns (uint) {
        uint _price = 0;
        uint _item_level = 0;
        //crafting items
        if (_item_type <= 192) {
            _item_level = _item_type % 16;
            if (_item_level == 0) {
                _item_level = 16;
            }
            uint _item_rarity;
            if (_item_type >= 129) {    //rare, x9
                _item_rarity = 9;
            } else if (_item_type >= 65) {  //uncommon, x3
                _item_rarity = 3;
            } else {    //common, x1
                _item_rarity = 1;
            }
            _price = _calc_itemPrice_fromLevel(_item_level) * _item_rarity;
        //fluffy
        } else if (_item_type >= 201 && _item_type <= 248) {
            if (_item_type <= 212) {    //fluffy
                _item_level = 21;
            } else if (_item_type <= 224) { //fluffier
                _item_level = 22;
            } else if (_item_type <= 236) { //fluffiest
                _item_level = 23;
            } else if (_item_type <= 248) { //doll
                _item_level = 24;
            }
            _price = _calc_itemPrice_fromLevel(_item_level);
        //twinkleSparkleGlitter
        } else if (_item_type >= 251 && _item_type <= 265) {
            _item_level = 22;   //=fluffier
            _price = _calc_itemPrice_fromLevel(_item_level);
        }
        return _price;
    }
    
    function calc_buybackPrice(uint _item) public view returns (uint) {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Craft mc = Murasaki_Craft(ma.address_Murasaki_Craft());
        (uint _item_type, , , , ,) = mc.items(_item);
        return calc_buybackPrice_from_itemType(_item_type);
    }
    
    function calc_buybackPrice_asArray() public view returns (uint[36] memory) {
        uint[36] memory _res;
        _res[1] = _calc_itemPrice_fromLevel(1);
        _res[2] = _calc_itemPrice_fromLevel(2);
        _res[3] = _calc_itemPrice_fromLevel(3);
        _res[4] = _calc_itemPrice_fromLevel(4);
        _res[5] = _calc_itemPrice_fromLevel(5);
        _res[6] = _calc_itemPrice_fromLevel(6);
        _res[7] = _calc_itemPrice_fromLevel(7);
        _res[8] = _calc_itemPrice_fromLevel(8);
        _res[9] = _calc_itemPrice_fromLevel(9);
        _res[10] = _calc_itemPrice_fromLevel(10);
        _res[11] = _calc_itemPrice_fromLevel(11);
        _res[12] = _calc_itemPrice_fromLevel(12);
        _res[13] = _calc_itemPrice_fromLevel(13);
        _res[14] = _calc_itemPrice_fromLevel(14);
        _res[15] = _calc_itemPrice_fromLevel(15);
        _res[16] = _calc_itemPrice_fromLevel(16);
        _res[21] = _calc_itemPrice_fromLevel(21);
        _res[22] = _calc_itemPrice_fromLevel(22);
        _res[23] = _calc_itemPrice_fromLevel(23);
        _res[24] = _calc_itemPrice_fromLevel(24);
        return _res;
    }

    event Buyback(uint indexed _summoner, uint _item, uint _price);    
    function buyback(uint _summoner, uint _item) external nonReentrant whenNotPaused {
        Murasaki_Address ma = Murasaki_Address(address_Murasaki_Address);
        Murasaki_Function_Share mfs = Murasaki_Function_Share(ma.address_Murasaki_Function_Share());
        Murasaki_Craft mc = Murasaki_Craft(ma.address_Murasaki_Craft());
        Murasaki_Parameter mp = Murasaki_Parameter(ma.address_Murasaki_Parameter());
        require(mp.isPaused() == false);
        require(mfs.check_owner(_summoner, msg.sender));
        require(mc.ownerOf(_item) == msg.sender);
        mc.safeTransferFrom(msg.sender, address(this), _item);
        uint _price = calc_buybackPrice(_item);
        require(_price > 0);
        //update amount paied
        amountPaied[_summoner] += _price;
        amountPaied_total += _price;
        //do not exceed amount per summoner after paying
        require(amountPaied[_summoner] <= amountPerSummoner);
        //pay
        payable(msg.sender).transfer(_price);
        //event
        emit Buyback(_summoner, _item, _price);
    }
}



