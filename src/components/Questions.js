import React from 'react'
import "./Questions.css"
import {useState, useEffect} from "react";

const Questions = () => {

    const [questions, setQuestions] = useState([])
    const [answers, setAnswers] = useState([])

    //Load questions
    useEffect( () => {
        const getQuestions = async () => {
        const questionsFromServer = await fetchQuestions()
        setQuestions(questionsFromServer)
        }

        getQuestions()
    }, [])

    //Fetch Tasks
    const fetchQuestions = async () => {
        const res = await fetch('http://localhost:8000/questions')
        const data = await res.json()
        return data
    }

    //Add question answer
    const addAnswer = (e) => {
        const quesId = e.target.name
        const ansId = e.target.value
        const newAnswers = answers.filter( (answer) => answer.quesId !== quesId)

        const newDict = {}
        newDict["quesId"] = quesId
        newDict["ansId"] = ansId

        const newAnswers2 = [...newAnswers, newDict]
        setAnswers(newAnswers2)
    }

    const uploadAnswers = async (ansInfo) => {
        const res = await fetch('http://localhost:8000/answers', 
            {
                method: "POST", 
                headers: {'Content-type': 'application/json'}, 
                body: JSON.stringify(ansInfo)
            }
        )
        const data = await res.json()
    }

    const formSubmit = (e) => {
        e.preventDefault()

        for(var i in questions){
            var flag = false

            for(var j in answers){

                if(questions[i].id == answers[j].quesId){
                    flag = true
                    break
                }
            }

            if(!flag){
                alert("Question " + questions[i].id + " is not answered")
                return
            }
        }
        uploadAnswers(answers)
    }

    return (
        <div className='container'>
            <form onSubmit={formSubmit}>

            
                {
                    questions.map(
                        (question) => (
                            <div>
                                <div className='questionTextContainer'>
                                    <div className='questionId'>{question.id}.</div>
                                    <div className='questionText'>{question.questionText}</div>
                                </div>
                                

                                <div>
                                    {
                                        question.options.map(
                                            (option) => (
                                                
                                                <div className='optionContainer' onChange={(e) => addAnswer(e)}>
                                                    <input type="radio" className='radio' name={question.id} value={option.id} ></input>
                                                    {/* <div className='optionId'>{option.id}.</div> */}
                                                    <div>{option.value}</div>
                                                </div>
                                            )
                                        )
                                    }
                                </div>

                            </div>
                        )
                    )
                }

                <input type="submit" className="login-btn-modal" value="Create" />

            </form>
            
        </div>
    )
}

export default Questions