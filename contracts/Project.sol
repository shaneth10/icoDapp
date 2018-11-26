pragma solidity ^0.4.17;

//SafeMath 机制就是通过简单的检查确保常见的数学运算不出现预期之外的结果
library SafeMath {
    function mul(uint a, uint b) internal pure returns (uint) {
        uint c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function div(uint a, uint b) internal pure returns (uint) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function sub(uint a, uint b) internal pure returns (uint) {
        assert(b <= a);
        return a - b;
    }

    function add(uint a, uint b) internal pure returns (uint) {
        uint c = a + b;
        assert(c >= a);
        return c;
    }
}

contract ProjectList {
    //使SafeMath机制生效
    using SafeMath for uint;
    address[] public projects;

    function createProject(string _description, uint _minInvest, uint _maxInvest, uint _goal) public {
        address newProject = new Project(_description, _minInvest, _maxInvest, _goal, msg.sender);
        projects.push(newProject);
    }

    function getProjects() public view returns(address[]) {
        return projects;
    }
}

contract Project {
    //使SafeMath机制生效
    using SafeMath for uint;

    struct Payment {
        string description;
        uint amount;
        address receiver;
        bool completed;
        //mapping把线性的访问时间优化到到常数访问时间
        mapping(address => bool) voters;
        uint voterCount;
    }

    address public owner;
    string public description;
    uint public minInvest;
    uint public maxInvest;
    uint public goal;
    uint public investorCount;
    mapping(address => uint) public investors;
    Payment[] public payments;

    modifier ownerOnly() {
        require(msg.sender == owner);
        _;
    }

    constructor(string _description, uint _minInvest, uint _maxInvest, uint _goal, address _owner) public {
        description = _description;
        minInvest = _minInvest;
        maxInvest = _maxInvest;
        goal = _goal;
        owner = _owner;
    }

    function contribute() public payable {
        require(msg.value >= minInvest);
        require(msg.value <= maxInvest);
        uint newBalance = 0;
        //显式的调用了 uint 类型变量的 add 方法
        newBalance = address(this).balance.add(msg.value);
        require(newBalance <= goal);

        investors[msg.sender] = msg.value;
        investorCount += 1;
    }

    function createPayment(string _description, uint _amount, address _receiver) ownerOnly public {
        require(msg.sender == owner);
        Payment memory newPayment = Payment({
            description: _description,
            amount: _amount,
            receiver: _receiver,
            completed: false,
            voterCount: 0
        });

        payments.push(newPayment);
    }

    function approvePayment(uint index) public {
        Payment storage payment = payments[index];

        // must be investor to vote
        require(investors[msg.sender] > 0);

        // can not vote twice
        require(!payment.voters[msg.sender]);

        payment.voters[msg.sender] = true;
        payment.voterCount += 1;
    }

    function doPayment(uint index) ownerOnly public {
        require(msg.sender == owner);

        Payment storage payment = payments[index];

        require(!payment.completed);
        //转账前我们需要账户余额大于等于当前需要支出的金额
        require(address(this).balance >= payment.amount);
        require(payment.voterCount > (investorCount / 2));

        payment.receiver.transfer(payment.amount);
        payment.completed = true;
    }

    function getSummary() public view returns (string, uint, uint, uint, uint, uint, uint, address) {
        return (
            description,
            minInvest,
            maxInvest,
            goal,
            address(this).balance,
            investorCount,
            payments.length,
            owner
        );
    }
}