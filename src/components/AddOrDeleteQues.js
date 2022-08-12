import React from 'react'
import "./ShowResponse.css"
import "./AddOrDeleteQues.css"
import {useState, useEffect} from "react";
import {FaPlus} from 'react-icons/fa'

const AddOrDeleteQues = () => {


    const [questions, setQuestions] = useState([])
    const [deleteReasoningModal, setDeleteReasoningModal] = useState(false)
    const [deleteReasoning, setDeleteReasoning] = useState("")


    useEffect( () => {
        const getQuestions = async () => {
        const questionsFromServer = await fetchQuestions()
        setQuestions(questionsFromServer)
        }

        getQuestions()
    }, [])

    const fetchQuestions = async () => {
        const res = await fetch('http://localhost:8000/questions')
        const data = await res.json()
        return data
    }


    const deleteClicked = (quesId) => {
        console.log("delete clicked", quesId)
        setDeleteReasoningModal(true)
    }

    const reasoningGiven = (e) => {
        e.preventDefault()
        if(!deleteReasoning){
            alert("Reason Can't be empty !!!")
            return
        }
        console.log(deleteReasoning)
        setDeleteReasoning("")
        setDeleteReasoningModal(false)
    }


    return (
        <>
        
            <div className='container'>
                <div >
                    Request to Update Questionnaire of PTSD Test - Change This
                </div>
                <hr className='line-psy'></hr>

                <div className='section'>Test Questions</div>
                <hr className='line-psy' style={{width:"30%"}}></hr>

                {
                    questions.map(
                        (question) => (
                            <div className='answersHandler'>

                                <div className='questionTextContainer'>
                                    <div className='questionId'>{question.id}.</div>
                                    <div className='questionText'>{question.questionText}</div>
                                    <div className='ques-dlt-btn' onClick={() => deleteClicked(question.id)}>Delete</div>
                                </div>

                                {
                                    question.options.map(
                                        (option) => (
                                            <div className='optionContainer'>
                                                <label className="ckbox-container-show">{option.value}
                                                    <input type="checkbox" disabled />
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

                <div className='add-new'>
                    <FaPlus className='icn' /> <div>Add New</div>
                </div>
            </div>

            {
                deleteReasoningModal && (
                    <div className='modal-dlt'>
                        <div onClick={() => {setDeleteReasoningModal(false); setDeleteReasoning("");} } className="overlay-dlt"></div>
                        <div className='modal-content-dlt'>
                            <div className='detailContainer-dlt'>
                                <div className='header-dlt'>Enter Reasoning</div>
                                <hr className='line-psy' style={{width:"40%"}}></hr>
                            </div>

                            <div className='input-dlt'>
                                <form onSubmit={reasoningGiven}>
                                    <input type="text" placeholder='Enter Reasoning' value={deleteReasoning} onChange={(e) => setDeleteReasoning(e.target.value)} />
                                    <input type="submit" value="Send" />
                                </form>
                            </div>
                        </div>
                    </div>
                )
            }


        </>
    )
}

export default AddOrDeleteQues