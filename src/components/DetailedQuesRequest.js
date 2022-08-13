import React from 'react'
import "./DetailedQuesReview.css"
import "./ShowResponse.css"
import {useState, useEffect} from "react";

const DetailedQuesRequest = () => {

    const [requestDetails, setRequestDetails] = useState([])

    useEffect( () => {
        const getRequests = async () => {
            const responsesFromServer = await fetchDetails()
            setRequestDetails(responsesFromServer)
        }
        //Uncomment This
        // getRequests()

        //Fetching from db.json was not working. remove this hardcoded value in implementation.
        const req = [
            {
                "id":2,
                "testName" : "HIV",
                "requestBy": "Doe",
                "mode":"Add",
                "quesId":200,
                "quesBody":"What Have you done?",
                "options":[
                  "gone", "eaten", "played"
                ],
                "reason":""
            }
        ]
        setRequestDetails(req)

    }, [])
    
    const fetchDetails = async () => {
        const res = await fetch('http://localhost:8000/detailedRequests/1')
        const data = await res.json()
        return data
    }


    return (
        <div className='container'>
            
            
            {
                requestDetails.map(
                    (request) => (
                        <>
                            <div >
                                {request.requestBy} has Requested to {request.mode} a question from { request.testName } Test
                            </div>
                            <hr className='line-psy'></hr>

                            <div className='answersHandler'>

                                <div className='questionTextContainer'>
                                    <div className='questionText'>{request.quesBody}</div>
                                </div>
                                

                                {
                                    request.options.map(
                                        (option) => (
                                            <div style={{"marginTop":"20px", "marginLeft":"2%"}} className='optionContainer'>
                                                <label className="ckbox-container-show">{option}
                                                    {
                                                        <input type="checkbox" disabled />
                                                    }
                                                    <span className="ckbox-checkmark-show"></span>
                                                        
                                                </label>
                                            </div>
                                        )
                                    )
                                }

                                

                                {
                                    (request.reason.length > 0) ? (
                                        <>
                                            <div className='reason'>
                                                <div style={{"marginRight":"10px"}}><b>Reason:</b></div>
                                                <div>{request.reason}</div>
                                            </div>

                                            
                                        </>
                                        
                                    ) : (<></>)
                                }

                                <div className='done-btn2'>
                                    Approve
                                </div>
                            </div>
                        </>
                        
                    )
                )
            }
            
            

        </div>
    )
}

export default DetailedQuesRequest