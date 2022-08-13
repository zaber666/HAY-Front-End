import React from 'react'
import "./ScoreNDResponse.css"
import { useState, useEffect } from 'react'

const ListQuesUpdates = () => {
    const [requests, setRequests] = useState([])

    useEffect( () => {
        const getRequests = async () => {
            const responsesFromServer = await fetchRequests()
            setRequests(responsesFromServer)
        }
        getRequests()
    }, [])
    
    const fetchRequests = async () => {
        const res = await fetch('http://localhost:8000/quesReviewRequests')
        const data = await res.json()
        return data
    }

    return (
        <div className='container'>

      
            <div className='test-name'>Questionnaire Update Requests</div>
            <hr className='line-psy'></hr>
            

            <table className="content-table">
                <thead>
                <tr>
                <th>Test Name</th>
                <th>Requested By</th>
                <th>Mode</th>
                <th>Response</th>
                </tr>
                </thead>

                <tbody>
                {
                    requests.map(
                    (request) => (
                        <tr>
                        <td>{request.testName}</td>
                        <td>{request.requestBy}</td>
                        <td>{request.mode}</td>
                        <td><div className='response-text'>See Request</div></td><br/> <br/>
                        </tr>
                    )
                    )
                }
                </tbody>
            </table>

        
        </div>
    )
}

export default ListQuesUpdates