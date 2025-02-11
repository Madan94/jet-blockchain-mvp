// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract cargotracking {
    struct Lorry {
        string lorryId;
        address owner;
        uint256 totalTrips;
        uint256 rewardPoints;
        bool isRegistered;
    }

    struct Shipment {
        string shipmentId;
        string fromLocation;
        string toLocation;
        string currentStatus;
        uint256 startTime;
        uint256 endTime;
        string lorryId;
        bool isCompleted;
    }

    mapping(string => Lorry) public lorries;
    mapping(string => Shipment) public shipments;

    event LorryRegistered(string lorryId, address owner);
    event ShipmentStarted(string shipmentId, string fromLocation, address lorry);
    event ShipmentCompleted(string shipmentId, string toLocation, uint256 efficiencyScore);

    modifier onlyRegisteredLorry(string memory _lorryId) {
        require(lorries[_lorryId].isRegistered, "Lorry not registered");
        _;
    }

    function registerLorry(string memory _lorryId) public {
        require(!lorries[_lorryId].isRegistered, "Lorry already registered");

        lorries[_lorryId] = Lorry({
            lorryId: _lorryId,
            owner: msg.sender,
            totalTrips: 0,
            rewardPoints: 0,
            isRegistered: true
        });

        emit LorryRegistered(_lorryId, msg.sender);
    }

    function startShipment(string memory _shipmentId, string memory _fromLocation, string memory _lorryId) public onlyRegisteredLorry(_lorryId) {
        require(!shipments[_shipmentId].isCompleted, "Shipment already completed");

        shipments[_shipmentId] = Shipment({
            shipmentId: _shipmentId,
            fromLocation: _fromLocation,
            toLocation: "",
            currentStatus: "In Transit",
            startTime: block.timestamp,
            endTime: 0,
            lorryId: _lorryId,
            isCompleted: false
        });

        emit ShipmentStarted(_shipmentId, _fromLocation, msg.sender);
    }

    function completeShipment(string memory _shipmentId, string memory _toLocation) public {
        require(!shipments[_shipmentId].isCompleted, "Shipment already completed");

        shipments[_shipmentId].toLocation = _toLocation;
        shipments[_shipmentId].currentStatus = "Completed";
        shipments[_shipmentId].endTime = block.timestamp;
        shipments[_shipmentId].isCompleted = true;

        uint256 efficiencyScore = calculateEfficiency(shipments[_shipmentId].startTime, shipments[_shipmentId].endTime);
        lorries[shipments[_shipmentId].lorryId].rewardPoints += efficiencyScore;
        lorries[shipments[_shipmentId].lorryId].totalTrips += 1;

        emit ShipmentCompleted(_shipmentId, _toLocation, efficiencyScore);
    }

    function calculateEfficiency(uint256 _startTime, uint256 _endTime) internal pure returns (uint256) {
        uint256 duration = _endTime - _startTime;
        return 1000 / (duration / 60 + 1);  // Simple efficiency calculation
    }

    function getLorryDetails(string memory _lorryId) public view returns (Lorry memory) {
        return lorries[_lorryId];
    }

    function getShipmentDetails(string memory _shipmentId) public view returns (Shipment memory) {
        return shipments[_shipmentId];
    }
}
