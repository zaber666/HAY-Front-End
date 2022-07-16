import React from 'react'
import "./ShowResponse.css"
import { useEffect, useState } from 'react'

const ShowResponse = () => {

    const [responseee, setResponse] = useState([])
    const [questionAns, setQuestionAns] = useState([])
  
    useEffect( () => {
        const getResponse = async () => {
            const responseFromServer = await fetchResponse()
            setResponse(responseFromServer)

            const questionAnsFromServer = await fetchQuestionAns()
            setQuestionAns(questionAnsFromServer)
        }

        getResponse()

    }, [])

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
            <div onClick={test}>
                System Report For <b><i>{ responseee.patientName }</i></b> agains <b><i>{responseee.testName}</i></b>
            </div>
            <hr className='line-psy'></hr>

            <div className='section'>Test Questions</div>
            <hr className='line-psy' style={{width:"30%"}}></hr>
            <div>{responseee.patientHeight} {responseee.patientWeight} {responseee.patientLocation} {responseee.systemScore}</div>

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
        </div>
    )
}

export default ShowResponse