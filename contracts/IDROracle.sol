// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract IDRUSDTOracle {
    // harga disimpan dalam format fixed point 1e6 (6 desimal)
    // misal 1 USDT = 15,300 IDR → disimpan sebagai 15300000
    uint256 private price;  
    address public owner;

    event PriceUpdated(uint256 newPrice, address updater);

    constructor(uint256 _initialPrice) {
        owner = msg.sender;
        price = _initialPrice;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    // update harga secara manual
    function updatePrice(uint256 _newPrice) external onlyOwner {
        price = _newPrice;
        emit PriceUpdated(_newPrice, msg.sender);
    }

    // ambil harga USDT → IDR
    function getPrice() external view returns (uint256) {
        return price;
    }

    // helper: konversi USDT ke IDR
    function convertUSDTtoIDR(uint256 usdtAmount) external view returns (uint256) {
        return (usdtAmount * price) / 1e6; // karena harga punya 6 desimal
    }

    // helper: konversi IDR ke USDT
    function convertIDRtoUSDT(uint256 idrAmount) external view returns (uint256) {
        return (idrAmount * 1e6) / price;
    }
}
