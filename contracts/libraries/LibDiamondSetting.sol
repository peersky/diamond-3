// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "hardhat/console.sol";

library LibDiamondSetting {

    bytes32 constant DIAMOND_STORAGE_POSITION = keccak256("diamond.standard.setting.storage");
    struct DiamondSettingStorage {
        address rim;
        uint256[] RimPermittedMeans;
        mapping (address => address) prongs;
        mapping(address => uint256[]) ProngsPermittedMeans;
        address paymentDestination;
    }


    function diamondSettingStorage() internal pure returns (DiamondSettingStorage storage ds) {
        bytes32 position = DIAMOND_STORAGE_POSITION;
        assembly {
            ds.slot := position
        }
    }

    function setRim(address _rim, address _paymentDestination) internal
    {
        DiamondSettingStorage storage ds = diamondSettingStorage();
        ds.rim = _rim;
        ds.paymentDestination = _paymentDestination;
    }

    function setProng(address _facet, address _prong) internal
    {
        DiamondSettingStorage storage ds = diamondSettingStorage();
        ds.prongs[_facet] = _prong;
    }

    function getRim() internal view returns (address)
    {
        DiamondSettingStorage storage ds = diamondSettingStorage();
        return ds.rim;
    }

    function getProng(address _facet) internal view returns (address)
    {
        DiamondSettingStorage storage ds = diamondSettingStorage();
        return ds.prongs[_facet];
    }

    function isRimmed() internal view returns (bool)
    {
        DiamondSettingStorage storage ds = diamondSettingStorage();
        return ds.rim != address(0);
    }

    function isPronged(address _facet) internal view returns (bool)
    {
        DiamondSettingStorage storage ds = diamondSettingStorage();
        return ds.prongs[_facet] != address(0);
    }

    function validateDiamondCall(address _facet, bytes4 _selector) internal
    {
        DiamondSettingStorage storage ds = diamondSettingStorage();

    }

    function validateFacetCall(address _facet, bytes4 _selector) internal
    {
        DiamondSettingStorage storage ds = diamondSettingStorage();

    }


}
