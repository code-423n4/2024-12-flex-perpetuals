// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console.sol";

library Uint2str {
    // Converts uint256 to a string with specified decimals (fractional part) and commas for thousands
    function uint2str(uint256 value, uint8 decimals) public pure returns (string memory) {
        // If decimals == 0, return just the integer part with commas
        if (decimals == 0) {
            return addCommas(uintToString(value));
        }

        uint256 tenPowerDecimals = 10 ** decimals; // 10^decimals to calculate fractional part
        uint256 wholePart = value / tenPowerDecimals; // Integer part
        uint256 fractionalPart = value % tenPowerDecimals; // Fractional part

        // Convert integer and fractional parts to strings, adding commas to the integer part
        string memory wholePartStr = addCommas(uintToString(wholePart));
        string memory fractionalPartStr = fractionalToString(fractionalPart, decimals);

        return string(abi.encodePacked(wholePartStr, ".", fractionalPartStr)); // Returns the string "integer.fractional"
    }

    // Converts uint256 to a string
    function uintToString(uint256 value) internal pure returns (string memory) {
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

    // Converts the fractional part to a string and adds leading zeros if necessary
    function fractionalToString(uint256 fractional, uint8 decimals) internal pure returns (string memory) {
        if (fractional == 0) {
            // If fractional part is 0, return a string with the necessary number of zeros
            bytes memory zeroes = new bytes(decimals);
            for (uint8 i = 0; i < decimals; i++) {
                zeroes[i] = "0";
            }
            return string(zeroes);
        }

        // Convert fractional part to a string
        string memory fractionalStr = uintToString(fractional);

        // If the fractional part is shorter than decimals, add leading zeros
        uint256 fractionalLength = bytes(fractionalStr).length;
        if (fractionalLength < decimals) {
            uint256 zeroesToAdd = decimals - fractionalLength;
            bytes memory zeroes = new bytes(zeroesToAdd);
            for (uint256 i = 0; i < zeroesToAdd; i++) {
                zeroes[i] = "0";
            }
            return string(abi.encodePacked(string(zeroes), fractionalStr));
        }

        return fractionalStr;
    }

    // Adds commas to the integer part (thousands separator)
    function addCommas(string memory numStr) internal pure returns (string memory) {
        bytes memory numBytes = bytes(numStr);
        uint256 len = numBytes.length;

        // No commas needed for numbers less than 1000
        if (len <= 3) {
            return numStr;
        }

        uint256 numCommas = (len - 1) / 3;
        bytes memory result = new bytes(len + numCommas);
        uint256 resultIndex = result.length - 1;
        uint256 numIndex = numBytes.length - 1;
        uint256 commaCounter = 0;

        // Iterate backwards and insert commas
        while (resultIndex > 0) {
            if (commaCounter == 3) {
                result[resultIndex--] = ","; // Insert comma after every 3 digits
                commaCounter = 0;
            }
            result[resultIndex] = numBytes[numIndex];
            if (numIndex > 0) {
                numIndex--;
            }
            if (resultIndex > 0) {
                resultIndex--;
            }
            commaCounter++;
        }

        // Handle the last digit (at index 0) without adding a comma before it
        result[resultIndex] = numBytes[0];

        return string(result);
    }
}
