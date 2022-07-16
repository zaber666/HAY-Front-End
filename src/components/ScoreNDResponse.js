import React from 'react'
import "./ScoreNDResponse.css"
import { useState, useEffect } from 'react'

const ScoreNDResponse = () => {

  const [responses, setResponses] = useState([])

  useEffect( () => {
    const getResponses = async () => {
      const responsesFromServer = await fetchResponses()
      setResponses(responsesFromServer)
    }
    getResponses()
  }, [])

  const fetchResponses = async () => {
    const res = await fetch('http://localhost:8000/responses')
    const data = await res.json()
    return data
  }


  return(
      <div className='container'>


        <div className='test-name'>Patient Scores And Responses</div>
        <hr className='line-psy'></hr>


        <table className="content-table">
          <thead>
          <tr>
            <th>Test Name</th>
            <th>Patient Name</th>
            <th>System Score</th>
            <th>Response</th>
          </tr>
          </thead>

          <tbody>
          {
            responses.map(
                (response) => (
                    <tr>
                      <td>{response.testName}</td>
                      <td>{response.patientName}</td>
                      <td>{response.systemScore}</td>
                      <td><div className='response-text'>Get Response</div></td><br/> <br/>
                    </tr>
                )
            )
          }
          </tbody>
        </table>


      </div>
  )
}

export default ScoreNDResponse