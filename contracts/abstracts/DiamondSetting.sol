// SPDX-License-Identifier: Apache-2.0

/**
 * Author: @Peersky https://github.com/peersky
 */

pragma solidity ^0.8.20;
import "../libraries/LibDiamondSetting.sol";
import "../libraries/LibAccessToken.sol";


abstract contract DiamondSetting {
    modifier rimmed(address sender, bytes4 selector) {
        LibDiamondSetting.DiamondSettingStorage storage rs = LibDiamondSetting.diamondSettingStorage();
        address rim = rs.rim;
        address benificiary = rs.benificiary;

        LibAccessToken.AccessByEnum senderMust = LibAccessToken.getAccessMeanOrThrow(rim, selector, sender);
        uint256 tokenBaseId = uint256(selector);
        uint256 tokenId = LibAccessToken.getTokenId(tokenBaseId, senderMust);


        LibAccessToken.before(rim, tokenId, sender, selector,benificiary );
        _;
        LibAccessToken.after(rim, tokenId, sender, selector);

    }
}
