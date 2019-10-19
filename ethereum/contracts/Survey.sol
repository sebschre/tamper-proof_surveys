pragma solidity ^0.5.3;

contract SurveyFactory {
    Survey[] public deployedSurveys;

    function createSurvey() public {
        Survey newSurvey = new Survey(msg.sender);
        deployedSurveys.push(newSurvey);
    }

    function getDeployedSurveys() public view returns (Survey[] memory) {
        return deployedSurveys;
    }
}

contract Survey {
    Question[] public questions;
    address public manager;

    modifier restrictedToManager() {
        require(msg.sender == manager, "Sender not authorized");
        _;
    }

    constructor (address creator) public {
        manager = creator;
    }

    function createQuestion(string memory questionText) public restrictedToManager {
        Question newQuestion = new QuestionClosedEnded(msg.sender, questionText);
        questions.push(newQuestion);
    }

    function getQuestionsCount() public view returns (uint) {
        return questions.length;
    }
}

contract Question {
    address public survey;
    string public questionText;
    Reponse[] public reponses;

    constructor (address creatorSurvey, string memory text) public {
        survey = creatorSurvey;
        questionText = text;
    }

    function answer(Reponse) external;
}

contract Reponse {
    address public respondant;
    function setAnswer() public;
}

contract QuestionClosedEnded is Question {
    string answerOptions;

    constructor (address creatorSurvey, string memory text) Question(creatorSurvey, text) public {}

    function answer() public {
        answerOptions = "yes";
    }
}

contract QuestionOpenEnded is Question {

}