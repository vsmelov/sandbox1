// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import '@openzeppelin/contracts/utils/structs/EnumerableSet.sol';


contract RemoveMock {
    using EnumerableSet for EnumerableSet.Bytes32Set;

    struct Property{
        bytes32 value;
    }

    struct Pool{
        bool enabled;
        mapping(bytes32 /*propertyName*/ => Property) properties;
        EnumerableSet.Bytes32Set propertyNames;
    }

    function getPropertyNames(bytes32 poolName) external view returns(string[] memory) {
        Pool storage pool = pools[poolName];
        string[] memory propertyNames = new string[](pool.propertyNames.length());
        for(uint256 i=0; i<pool.propertyNames.length(); i++){
            bytes32 name = pool.propertyNames.at(i);
            string memory nameString = string(abi.encodePacked(name));
            propertyNames[i] = nameString;
        }
        return propertyNames;
    }

    function getPropertyNameByIndex(bytes32 poolName, uint256 i) external view returns(string memory) {
        Pool storage pool = pools[poolName];
        bytes32 name = pool.propertyNames.at(i);
        string memory nameString = string(abi.encodePacked(name));
        return nameString;
    }

    function getPoolEnabled(bytes32 poolName) external view returns(bool){
        return pools[poolName].enabled;
    }


    mapping(bytes32 /*poolName*/ => Pool) internal pools;

    modifier requirePoolEnabled(bytes32 poolName){
        require(pools[poolName].enabled, "requirePoolEnabled failed");
        _;
    }

    modifier requirePoolDisabled(bytes32 poolName){
        require(!pools[poolName].enabled, "requirePoolDisabled failed");
        _;
    }

    function removePool(bytes32 poolName) external {
        pools[poolName].properties = mapping(bytes32 /*propertyName*/ => Property);
        delete pools[poolName];
        require(pools[poolName].propertyNames.length() == 0, "pools[poolName].length() == 0 failed"); // todo remove
    }

    function addProperty(
        bytes32 poolName,
        bytes32 propertyName,
        bytes32 propertyValue
    ) external requirePoolEnabled(poolName) {
        bool wasAdded = pools[poolName].propertyNames.add(propertyName);
        require(wasAdded, "wasAdded failed");
        pools[poolName].properties[propertyName].value = propertyValue;
    }

    function getProperty(
        bytes32 poolName,
        bytes32 propertyName
    ) external view returns(bytes32) {
        return pools[poolName].properties[propertyName].value;
    }

//    function bytes32ToString(bytes32 x) pure returns (string) {
//        bytes memory bytesString = new bytes(32);
//        uint charCount = 0;
//        for (uint j = 0; j < 32; j++) {
//            byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
//            if (char != 0) {
//                bytesString[charCount] = char;
//                charCount++;
//            }
//        }
//        bytes memory bytesStringTrimmed = new bytes(charCount);
//        for (j = 0; j < charCount; j++) {
//            bytesStringTrimmed[j] = bytesString[j];
//        }
//        return string(bytesStringTrimmed);
//    }

    function getPropertyString(
        bytes32 poolName,
        bytes32 propertyName
    ) external view returns(string memory) {
        return string(abi.encodePacked(pools[poolName].properties[propertyName].value));
    }

    function addPool(
        bytes32 poolName
    ) external requirePoolDisabled(poolName) {
        pools[poolName].enabled = true;
    }
}
