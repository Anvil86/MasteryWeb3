// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract MasteryWeb3 {
    struct Course{
        address owner;
        string title;
        string description;
        uint256 value;
        uint256 expirationDate;
        address[] subscribers;
    }

    mapping (uint256 => Course) public courses;

    uint256 public numCourses = 0;

    function createCourse(address _owner, string memory _title, string memory _description, uint256 _value, uint256 _expirationDate) public returns (uint256) {
        Course storage course = courses[numCourses];

        require(course.expirationDate < block.timestamp, "Expiration date must be in the future");

        course.owner = _owner;
        course.title = _title;
        course.description = _description;
        course.value = _value;
        course.expirationDate = _expirationDate;

        numCourses++;

        return numCourses - 1;
    }

    function enrollCourse(uint256 _id) public payable {
        
        Course storage course = courses[_id];

        course.subscribers.push(msg.sender);

        (bool sent,) = payable(course.owner).call{value: course.value}("");

    }

    function getCourses() public view returns(Course[] memory) {
        Course[] memory allCourses = new Course[](numCourses);
        
        for(uint i = 0; i < numCourses; i++){
            Course storage item = courses[i];
            allCourses[i] = item;
        }

        return allCourses;
    }

    function getSubscribers(uint256 _id) view public returns(address[] memory) {
        return(courses[_id].subscribers);

    }

}