// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LearningHub {
    string public name = "LearningHubToken";
    string public symbol = "LHT";
    uint8 public decimals = 18;
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event CourseCompleted(address indexed user, uint256 courseId, uint256 reward);

    struct Course {
        string title;
        string description;
        uint256 reward;
        bool isActive;
    }

    Course[] public courses;

    constructor() {
        totalSupply = 1000000 * (10 ** uint256(decimals)); // Initial supply
        balanceOf[msg.sender] = totalSupply; // Assign all tokens to the contract creator
    }

    function createCourse(string memory _title, string memory _description, uint256 _reward) public {
        courses.push(Course({
            title: _title,
            description: _description,
            reward: _reward,
            isActive: true
        }));
    }

    function completeCourse(uint256 _courseId) public {
        require(_courseId < courses.length, "Course does not exist");
        require(courses[_courseId].isActive, "Course is not active");

        // Reward the user
        balanceOf[msg.sender] += courses[_courseId].reward;
        emit CourseCompleted(msg.sender, _courseId, courses[_courseId].reward);
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[_from] >= _value, "Insufficient balance");
        require(allowance[_from][msg.sender] >= _value, "Allowance exceeded");
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }
}