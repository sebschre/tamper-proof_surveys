pragma solidity >=0.4.22 <0.6.0;

/// @title Survey
contract Survey {

    struct Respondant {
        bool hasAnswered;  // if true, that person already answered
        bool hasRightToAnswer;  // right to answer granted
        uint answerIndex;      // index in the answer array
    }

    struct Answer {
        bytes32 answerText;
        uint answerCount; // number of accumulated answered
    }

    address public owner;
    string public question;
    event rightToAnswerGranted(address respondant_address);
    mapping(address => Respondant) public respondants;
    Answer[] public answers;

    constructor(string memory _question, bytes32[] memory _answerTexts) public {
        owner = msg.sender;
        question = _question;

        for (uint i = 0; i < _answerTexts.length; i++) {
            answers.push(Answer({
                answerText: _answerTexts[i],
                answerCount: 0
            }));
        }
    }

    // Give `respondant` the right to answer in this survey.
    function grantRightToAnswer(address _respondant_address) public restrictedToOwner {
        require(
            !respondants[_respondant_address].hasAnswered,
            "The respondant already answered."
        );
        respondants[_respondant_address].hasRightToAnswer = true;
        emit rightToAnswerGranted(_respondant_address);
    }

    function answer(uint _answerIndex) public {
        Respondant storage sender = respondants[msg.sender];
        require(sender.hasRightToAnswer, "Has no right to vote");
        require(!sender.hasAnswered, "Already answered.");
        sender.hasAnswered = true;
        sender.answerIndex = _answerIndex;

        // If `_answerIndex` is out of the range of the array,
        // this will throw automatically and revert all
        // changes.
        answers[_answerIndex].answerCount += 1;
    }

    modifier restrictedToOwner() {
        require(msg.sender == owner, "Only owner is authorized for this");
        _;
    }
}