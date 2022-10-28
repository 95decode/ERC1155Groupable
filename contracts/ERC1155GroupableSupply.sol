// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";

/**
 * @dev Extension of {ERC1155} that makes token groups with `groupId`
 */
abstract contract ERC1155GroupableSupply is ERC1155, ERC1155Supply {
    // Optional mapping for group URIs
    mapping(uint256 => string) private _groupURIs;

    // Mapping from group ID to total supply
    mapping(uint256 => uint256) private _groupTotalSupply;

    // Mapping from token ID to unallocated supply
    mapping(uint256 => uint256) private _unAllocSupply;

    // Mapping from group ID to original token ID
    mapping(uint256 => uint256) private _groupIds;

    /**
     * @dev Group URI in with given `groupId`
     */
    function groupURI(uint256 groupId) public view virtual returns (string memory) {
        return _groupURIs[groupId];
    }

    /**
     * @dev Group Id in with given `tokenId`
     */
    function groupID(uint256 tokenId) public view virtual returns (uint256) {
        return _groupIds[tokenId];
    }

    /**
     * @dev Total amount of tokens in with a given `groupId`.
     */
    function groupTotalSupply(uint256 groupId) public view virtual returns (uint256) {
        return _groupTotalSupply[groupId];
    }

    /**
     * @dev Indicates whether any token exist with a given `groupId`, or not.
     */
    function groupExists(uint256 groupId) public view virtual returns (bool) {
        return ERC1155GroupableSupply.groupTotalSupply(groupId) > 0;
    }

    /**
     * @dev See {ERC1155-balanceOf}.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     *//*
    function groupBalanceOf(address account, uint256 groupId, uint256 groupSubId) public view virtual returns (uint256) {
        return super.balanceOf(account, tokenIdFromGroupId(groupId, groupSubId));
    }
    */

    /**
     * @dev Set group URI
     */
    function _setGroupURI(uint256 groupId, string memory uri) internal virtual {
        _groupURIs[groupId] = uri;
    }

    /**
     * @dev Map `groupId` from `tokenId`
     * 
     * Requirements:
     * 
     * - the token id must not be grouped
     * - the group id must not be zero
     */
    function _setGroup(uint256 tokenId, uint256 groupId) internal virtual {
        require(groupId != 0, "ERC1155Groupable: group Id must not be zero");
        require(_groupIds[tokenId] == 0, "ERC1155Groupable: token Id is aleady grouped");
        
        if(_unAllocSupply[tokenId] > 0) {
            _groupTotalSupply[groupId] += _unAllocSupply[tokenId];
            _unAllocSupply[tokenId] = 0;
        }

        _groupIds[tokenId] = groupId;
    }

    /**
     * @dev Change group with a given `tokenId` and `groupId`.
     */
    function _changeGroup(uint256 tokenId, uint256 groupId) internal virtual {
        require(groupId != 0, "ERC1155Groupable: group Id must not be zero");
        require(_groupIds[tokenId] != 0, "ERC1155Groupable: token Id is not grouped");

        uint256 supply = totalSupply(tokenId);
        _groupTotalSupply[_groupIds[tokenId]] -= supply;
        _groupTotalSupply[groupId] += supply;

        _groupIds[tokenId] = groupId;
    }

    /**
     * @dev See {ERC1155-_beforeTokenTransfer}.
     */
    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual override(ERC1155, ERC1155Supply) {
        if (from == address(0)) {
            for (uint256 i = 0; i < ids.length; ++i) {
                _groupIds[ids[i]] != 0 ? _groupTotalSupply[_groupIds[ids[i]]] += amounts[i] : _unAllocSupply[ids[i]] += amounts[i];
            }
        }

        if (to == address(0)) {
            for (uint256 i = 0; i < ids.length; ++i) {
                uint256 id = ids[i];
                uint256 amount = amounts[i];
                if(_groupIds[id] != 0) {
                    uint256 supply = _groupTotalSupply[_groupIds[id]];
                    require(supply >= amount, "ERC1155: burn amount exceeds groupTotalSupply");
                    unchecked {
                        _groupTotalSupply[_groupIds[id]] = supply - amount;
                    }
                } else {
                    uint256 supply = totalSupply(id);
                    require(supply >= amount, "ERC1155: burn amount exceeds totalSupply");
                    unchecked {
                        _unAllocSupply[id] = supply - amount;
                    }
                }
            }
        }

        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}