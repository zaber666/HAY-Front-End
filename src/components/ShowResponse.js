import React from 'react'
import "./ShowResponse.css"
import { useEffect, useState } from 'react'

const ShowResponse = () => {

    const [responseee, setResponse] = useState([])
    const [questionAns, setQuestionAns] = useState([])
    const [comment, setComment] = useState([])

    const [disorders, setDisorders] = useState([])
    const [responseDisorders, setResponseDisorder] = useState({})
  
    useEffect( () => {
        const getResponse = async () => {
            const responseFromServer = await fetchResponse()
            setResponse(responseFromServer)

            const questionAnsFromServer = await fetchQuestionAns()
            setQuestionAns(questionAnsFromServer)

            const disordersFromServer = await fetchDisorders()
            setDisorders(disordersFromServer)
            
            var disorderDict = {}
            disordersFromServer.map(
                (disorder) => disorderDict[disorder] = false
            );
            setResponseDisorder(disorderDict);
        }
        getResponse()

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

    const uploadDisorders = async(e) => {
        e.preventDefault();

        const res = await fetch('http://localhost:8000/disorderSugesstion', 
            {
                method: "POST", 
                headers: {'Content-type': 'application/json'}, 
                body: JSON.stringify(responseDisorders)
            }
        )
        const data = await res.json()
    }

    const fetchResponse = async () => {
        const res = await fetch('http://localhost:8000/responseBasic')
        const data = await res.json()
        return data
    }

    const fetchQuestionAns = async () => {
        const res = await fetch('http://localhost:8000/responseQuestions')
        const data = await res.json()
        return data
    }

    const fetchDisorders = async () => {
        const res = await fetch('http://localhost:8000/disorder_list')
        const data = await res.json()
        return data
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
            <div >
                System Report For <b><i>{ responseee.patientName }</i></b> agains <b><i>{responseee.testName}</i></b>
            </div>
            <hr className='line-psy'></hr>

            <div className='section'>Test Questions</div>
            <hr className='line-psy' style={{width:"30%"}}></hr>

            {
                questionAns.map(
                    (question) => (
                        <div className='answersHandler'>

                            <div className='questionTextContainer'>
                                <div className='questionId'>{question.id}.</div>
                                <div className='questionText'>{question.questionText}</div>
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


            <div className='section'>Add Comment</div>
            <hr className='line-psy' style={{width:"30%"}}></hr>
            <div className='commentContainer'>
                <textarea className='commentInput' rows="5" cols="70" placeholder='Enter Comment' value={comment} onChange={(e) => setComment(e.target.value)}></textarea>

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