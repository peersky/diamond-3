// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "hardhat/console.sol";
import {ERC1155Burnable} from "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";

library LibAccessToken {
    enum AccessByEnum {
        HAVING,
        LOCKING,
        BURNING,
        PAYING,
        DENIED
    }

    function getAccessMeanOrThrow(
        address tokenContract,
        uint256 baseTokenId,
        address sender,
        AccessByEnum[] memory permittedAccessMeans
    ) internal view returns (AccessByEnum) {
        ERC1155Burnable accessToken = ERC1155Burnable(tokenContract);
        for (uint256 i = 0; i < permittedAccessMeans.length; i += 2) {
            if (
                accessToken.balanceOf(sender, baseTokenId + uint256(permittedAccessMeans[i])) >=
                baseTokenId + uint256(permittedAccessMeans[i + 1])
            ) return permittedAccessMeans[i];
        }
        revert("LibAccessToken: cannot access this selector");
    }

    function getDesiredTokenId(uint256 baseTokenId, AccessByEnum accessingBy) internal pure returns (uint256) {
        return baseTokenId + uint256(accessingBy) * 2;
    }

    function getBaseTokenid(uint32 selector) internal pure returns (uint256) {
        return uint256(selector) << 224;
    }

    function getDesiredTokenIdFromSelector(uint32 selector, AccessByEnum accessingBy) internal pure returns (uint256) {
        return getDesiredTokenId(getBaseTokenid(selector), accessingBy);
    }

    function beforeCall(
        address tokenAddress,
        AccessByEnum accessingBy,
        uint256 baseTokenId,
        address sender,
        address benificiary
    ) internal {
        ERC1155Burnable accessToken = ERC1155Burnable(tokenAddress);
        if (accessingBy == AccessByEnum.BURNING) {
            accessToken.burn(sender, baseTokenId + uint256(AccessByEnum.BURNING) * 2, 1);
        } else if (accessingBy == LibAccessToken.AccessByEnum.LOCKING) {
            accessToken.safeTransferFrom(
                sender,
                address(this),
                baseTokenId + uint256(AccessByEnum.LOCKING) * 2,
                1,
                bytes("")
            );
        } else if (accessingBy == LibAccessToken.AccessByEnum.PAYING) {
            accessToken.safeTransferFrom(
                sender,
                benificiary,
                baseTokenId + uint256(AccessByEnum.PAYING) * 2,
                1,
                bytes("")
            );
        }
    }

    function afterCall(address tokenAddress, AccessByEnum accessingBy, uint256 baseTokenId, address sender) internal {
        ERC1155Burnable accessToken = ERC1155Burnable(tokenAddress);
        if (accessingBy == AccessByEnum.HAVING) {
            require(
                accessToken.balanceOf(sender, baseTokenId + uint256(AccessByEnum.HAVING) * 2) >=
                    accessToken.balanceOf(address(this), baseTokenId + uint256(AccessByEnum.HAVING) * 2 + 1),
                "LibAccessToken: not enough access token after call"
            );
        } else if (accessingBy == LibAccessToken.AccessByEnum.LOCKING) {
            accessToken.safeTransferFrom(
                address(this),
                sender,
                baseTokenId + uint256(AccessByEnum.LOCKING) * 2,
                1,
                bytes("")
            );
        }
    }
}
