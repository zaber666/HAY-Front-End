import React from 'react'
import "./ShowResponse.css"
import { useEffect, useState } from 'react'
import {getToken} from "./Variables";

const ShowResponse = (props) => {

    const [responseee, setResponse] = useState({
        patient_name: 'sx', height_inches: -5, weight_kgs: -7, patient_location: 'milky way'
    })
    const [questionAns, setQuestionAns] = useState([])
    const [comment, setComment] = useState([])

    const [disorders, setDisorders] = useState(['UH', 'HY'])
    const [responseDisorders, setResponseDisorder] = useState({})

    useEffect( () => {
        const getResponse = async (trId) => {
            const responseFromServer = await fetchResponse(trId)
            setResponse(responseFromServer)

            const questionAnsFromServer = await fetchQuestionAns(trId)
            setQuestionAns(questionAnsFromServer)

            const disordersFromServer = await fetchDisorders(trId)
            setDisorders(disordersFromServer)

            var disorderDict = {}
            disordersFromServer.map(
                (disorder) => disorderDict[disorder] = false
            );
            setResponseDisorder(disorderDict);
        }

        getResponse(props.testResultId)

    }, [])

    const commentUpload = async (comment) => {
        const res = await fetch('http://localhost:5000/submit_comment/' + props.testResultId,
            {
                method: "POST", 
                headers: {'Content-type': 'application/json', 'x-access-token': getToken()},
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

    const uploadDisorders = async(e) => {
        e.preventDefault();

        const res = await fetch('http://localhost:5000/disorder_suggestions/' + props.testResultId,
            {
                method: "POST",
                headers: {'Content-type': 'application/json', 'x-access-token': getToken()},
                body: JSON.stringify(responseDisorders)
            }
        )
        const data = await res.json()
    }


    const fetchResponse = async (trId) => {
        const res = await fetch('/responseBasic/' + trId, {method: "GET", headers: {'Accept': 'application/vnd.api+json'
                            , 'x-access-token': getToken()}})
        const data = await res.json()
        console.log("From fetch response", data.responseBasic)
        return data.responseBasic
    }

    const fetchQuestionAns = async (trId) => {
        const res = await fetch('/show_patient_responses/' + trId, {method: "GET", headers: {'Accept': 'application/vnd.api+json'
                            , 'x-access-token': getToken()}})
        // console.log(res)
        const data = await res.json()

        return data.responseQuestions
    }


    const fetchDisorders = async () => {
        const res = await fetch('/api/diseases', {method: "GET", headers: {'Accept': 'application/vnd.api+json'}})
        console.log('Before json')
        const data = await res.json()
        console.log(data)
        const _data = data['data'].map((x) => x.attributes.name)
        console.log('After json')
        console.log(_data)
        return _data
    }



    const handleList = (e) => {
        var tempDict = {}
        for (const [key, value] of Object.entries(responseDisorders)){
            tempDict[key] = value
        }
        tempDict[e.target.value] = e.target.checked;
        setResponseDisorder(tempDict);
    }
    return (
        <div className='container'>
            { console.log('Props:', props) }
            { responseee &&
            <div>
                System Report For <b><i>{ responseee.patient_name }</i></b> against <b><i>{responseee.test_name}</i></b>
            </div> }
            <hr className='line-psy'></hr>

            <div className='section'>Test Questions</div>
            <hr className='line-psy' style={{width:"30%"}}></hr>
            <div>{responseee.height_inches} {responseee.weight_kgs} {responseee.patient_location} {responseee.score}</div>

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
                <div className='optionContainer'>{responseee.height_inches}</div>

                <div className='questionTextContainer'>
                    <div className='questionId2'>4.</div>
                    <div className='questionText'>Weight</div>
                </div>
                <div className='optionContainer'>{responseee.weight_kgs}</div>

                <div className='questionTextContainer'>
                    <div className='questionId2'>5.</div>
                    <div className='questionText'>Location</div>
                </div>
                <div className='optionContainer'>{responseee.patientLocation}</div>
            </div>


            <div className='section'>System Score</div>
            <hr className='line-psy' style={{width:"30%"}}></hr>
            <div className='optionContainer'>{responseee.systemScore}</div>


            <div className='section'>Add Suggestions</div>
            <hr className='line-psy' style={{width:"30%"}}></hr>
            <div className='commentContainer'>
                <textarea className='commentInput' rows="5" cols="70" placeholder='Enter Sugesstions' value={comment} onChange={(e) => setComment(e.target.value)}></textarea>

                <div className="commentBtn" onClick={onCommentPost}>
                    <span className='commentSpan'>Comment</span>
                </div>
            </div>


            <div className='section'>Add Possible Disorder</div>
            <hr className='line-psy' style={{width:"30%"}}></hr>

            {
                disorders.map(
                    (disorder) => (
                        <div className='optionContainer'>

                            <label className="ckbox-container-show">{disorder}
                                <input type="checkbox" value={disorder} onChange={(e) => handleList(e)}/>
                                <span className="ckbox-checkmark-show"></span>

                            </label>

                        </div>
                    )
                )
            }

            <div className="notifyBtn" onClick={uploadDisorders}>
                <span className='notifySpan'>Notify</span>
            </div>


        </div>
    )
}

export default ShowResponse