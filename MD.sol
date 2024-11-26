// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DecentralizedMarketplace {
    struct Product {
        uint id;
        address payable seller;
        string name;
        string description;
        uint price;
        bool sold;
    }

    uint public productCount;
    mapping(uint => Product) public products;

    event ProductListed(uint id, string name, uint price, address seller);
    event ProductSold(uint id, address buyer);

    // List a new product
    function listProduct(string memory _name, string memory _description, uint _price) public {
        productCount++;
        products[productCount] = Product(productCount, payable(msg.sender), _name, _description, _price, false);
        emit ProductListed(productCount, _name, _price, msg.sender);
    }

    // Buy a product
    function buyProduct(uint _id) public payable {
        Product storage product = products[_id];
        require(_id > 0 && _id <= productCount, "Product does not exist");
        require(msg.value == product.price, "Incorrect price sent");
        require(!product.sold, "Product already sold");
        
        // Mark product as sold and transfer funds to the seller
        product.seller.transfer(msg.value);
        product.sold = true;
        
        emit ProductSold(_id, msg.sender);
    }
}
