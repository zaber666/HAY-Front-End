import React from 'react'
import "./ShowResponse.css"
import { useEffect, useState } from 'react'
import {getToken} from "./Variables";

const ShowResponse = (props) => {

    const [responseee, setResponse] = useState({
        patient_name: 'sx'
    })
    const [questionAns, setQuestionAns] = useState([])
    const [comment, setComment] = useState([])

    const [disorders, setDisorders] = useState([])
    const [responseDisorders, setResponseDisorder] = useState({})

    useEffect( () => {
        const getResponse = async (trId) => {
            const responseFromServer = await fetchResponse(trId)
            setResponse(responseFromServer)

            const questionAnsFromServer = await fetchQuestionAns(trId)
            setQuestionAns(questionAnsFromServer)
        }

        getResponse(props.testResultId)

    }, [])

    const commentUpload = async (comment) => {
        const res = await fetch('http://localhost:8000/comment_response', 
            {
                method: "POST", 
                headers: {'Content-type': 'application/json'}, 
                body: JSON.stringify(comment)
            }
        )
        const data = await res.json()
    }

    const onCommentPost = (e) => {
        e.preventDefault();

        if(!comment){
            alert("Comment is empty");
            return;
        }
        commentUpload({comment});
        setComment('');
    }

    const fetchResponse = async (trId) => {
        const res = await fetch('/responseBasic/' + trId, {method: "GET", headers: {'Accept': 'application/vnd.api+json'
                            , 'x-access-token': getToken()}})
        // console.log(res)
        const data = await res.json()
        console.log('from fetch response', data)
        return data.responseBasic
    }

    const fetchQuestionAns = async (trId) => {
        const res = await fetch('/show_patient_responses/' + trId, {method: "GET", headers: {'Accept': 'application/vnd.api+json'
                            , 'x-access-token': getToken()}})
        // console.log(res)
        const data = await res.json()

        return data.responseQuestions
    }

    const test = () => {
        console.log("henlo")
        var l = Object.keys(responseee).length
        console.log(l)
        for( const [key, value] of Object.entries(responseee)){
            console.log(key)
        }
        console.log("henlo2")
    }

    return (
        <div className='container'>
            { console.log('Props:', props) }
            { responseee &&
            <div onClick={test}>
                System Report For <b><i>{ responseee.patient_name }</i></b> against <b><i>{responseee.test_name}</i></b>
            </div> }
            <hr className='line-psy'></hr>

            <div className='section'>Test Questions</div>
            <hr className='line-psy' style={{width:"30%"}}></hr>
            <div>{responseee.patient_height} {responseee.patient_weight} {responseee.patient_location} {responseee.score}</div>

            {
                questionAns.map(
                    (question, idx) => (
                        <div className='answersHandler'>

                            <div className='questionTextContainer'>
                                <div className='questionId'>{idx + 1}.</div>
                                <div className='questionText'>{question.question_text}</div>
                            </div>

                            {
                                question.options.map(
                                    (option) => (
                                        <div className='optionContainer'>

                                            <label className="ckbox-container-show">{option.value}
                                                {
                                                    option.checked? (<input type="checkbox" disabled checked />) :(<input type="checkbox" disabled />)
                                                }
                                                <span className="ckbox-checkmark-show"></span>

                                            </label>
                                        </div>
                                    )
                                )
                            }
                        </div>
                    )
                )
            }

            <div className='section'>Demographic Informations</div>
            <hr className='line-psy' style={{width:"30%"}}></hr>

            <div className='answerHandler'>

                <div className='questionTextContainer'>
                    <div className='questionId2'>1.</div>
                    <div className='questionText'>Age</div>
                </div>
                <div className='optionContainer'>{responseee.patientAge}</div>

                <div className='questionTextContainer'>
                    <div className='questionId2'>2.</div>
                    <div className='questionText'>Gender</div>
                </div>
                <div className='optionContainer'>{responseee.patientGender}</div>

                <div className='questionTextContainer'>
                    <div className='questionId2'>3.</div>
                    <div className='questionText'>Height</div>
                </div>
                <div className='optionContainer'>{responseee.patientHeight}</div>

                <div className='questionTextContainer'>
                    <div className='questionId2'>4.</div>
                    <div className='questionText'>Weight</div>
                </div>
                <div className='optionContainer'>{responseee.patientWeight}</div>

                <div className='questionTextContainer'>
                    <div className='questionId2'>5.</div>
                    <div className='questionText'>Location</div>
                </div>
                <div className='optionContainer'>{responseee.patientLocation}</div>
            </div>


            <div className='section'>System Score</div>
            <hr className='line-psy' style={{width:"30%"}}></hr>
            <div className='optionContainer'>{responseee.systemScore}</div>
        </div>
    )
}

export default ShowResponse