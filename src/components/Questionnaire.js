import React, {useEffect, useState} from 'react';
import "./Questions.css"
import ReactDOM from 'react-dom';
import {questionnaire_post_response} from "./Variables";

const callRestApi = async (restEndpoint) => {
    const response = await fetch(restEndpoint, {method: "GET", headers: {'Accept': 'application/vnd.api+json'}});
    console.log(response)
    const jsonResponse = await response.json();
    // console.log(jsonResponse.data.relationships.questions.data);
    return jsonResponse;
};

const callRestApiForPost = async (restEndpoint, message_body) => {
    const response = await fetch(restEndpoint, {
        method: "POST", headers: {'Accept': 'application/vnd.api+json'
            , 'Content-Type': 'application/vnd.api+json'}
        , body: message_body});
    console.log(response)
    const jsonResponse = await response.json();
    // console.log(jsonResponse.data.relationships.questions.data);
    return jsonResponse;
};

var options = {}


export function OptionText(props) {

    const restEndPoint = '/api/options/' + props.optionId;

    const [apiResponse, setApiResponse] = useState({
        option_text: "not loaded yet",
        option_id: 0
    });

     useEffect(() => {
        callRestApi(restEndPoint).then(
            result => setApiResponse({
                option_text: result.data.attributes.option_text,
                option_id: result.data.attributes.option_id
            }));
    }, []);

     return (
         <div className="form-check form-check-inline">
             <input className="form-check-input" type="radio" className='radio' name={props.questionId} value={apiResponse.option_id}
                onClick={() => {options[props.questionId] = props.optionId; console.log(options)}}/>
                 <label className="form-check-label" htmlFor="inlineRadio1">{apiResponse.option_text}</label>
         </div>

    );
}

export function ListOptionsOfAQuestion(props) {
    console.log('props', props)

    const restEndPoint = '/api/questions/' + props.questionId;

    const [apiResponse, setApiResponse] = useState({
        question_text: "not loaded yet",
        question_id: 0,
        options: []
    });

     useEffect(() => {
        callRestApi(restEndPoint).then(
            result => setApiResponse({
                question_text: result.data.attributes.question_text,
                question_id: result.data.attributes.question_id,
                options: result.data.relationships.options.data.sort((a, b) => a.id - b.id)
            }));
    }, []);

     return (
        <div>
            <div className='questionTextContainer'>
                <div className='questionId'> {props.key_id}.</div>
                <div className='questionText'>{apiResponse.question_text}</div>
            </div>
            <div className='optionContainer'>
            {apiResponse.options.map((option, idx) => <OptionText optionId={option.id} questionId={apiResponse.question_id}/>)}
            </div>
            <br/>
        </div>
    );
}

export function ListQuestionsOfATest(props) {

    const restEndPoint = '/api/tests/' + props.testId;

    const [apiResponse, setApiResponse] = useState({
        test_name: "not loaded yet",
        test_description: "not loaded yet",
        test_id: 0,
        questions: []
    });

    useEffect(() => {
        callRestApi(restEndPoint).then(
            result => setApiResponse({
                test_name: result.data.attributes.name,
                test_description: result.data.attributes.description,
                test_id: result.data.test_id,
                questions: result.data.relationships.questions.data.sort((a, b) => a.id - b.id)
            }));
    }, []);

    return (
        <div className='container'>
            <h1>Test Name: {apiResponse.test_name}</h1>
            <p>Test Description: {apiResponse.test_description}</p>
            <form >
            {apiResponse.questions.map((question, idx) => <ListOptionsOfAQuestion
                questionId={question.id} key_id={idx+1}/>)}
            </form>

            <input type="submit" className="login-btn-modal" value="Submit" style={{width: '10%'}}
                onClick={() => {
                    console.log("Options: ", options);
                    const post_response = questionnaire_post_response(props.testId, options);
                    console.log(post_response);
                    callRestApiForPost('http://localhost:5000/api/tr', post_response).then(r => {console.log(r)});
                }}/>
        </div>
    );
};