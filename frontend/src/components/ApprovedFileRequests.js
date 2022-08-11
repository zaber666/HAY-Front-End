import React from 'react'
import "./ScoreNDResponse.css"
import { useState, useEffect } from 'react'
import {useNavigate} from "react-router-dom";
import {getToken} from "./Variables";

const ScoreNDResponse = () => {

  const [responses, setResponses] = useState([])
  const navigate = useNavigate()

  useEffect( () => {
    const getResponses = async () => {
      const responsesFromServer = await fetchResponses()
      setResponses(responsesFromServer)
    }
    getResponses()
  }, [])

  const fetchResponses = async () => {
    const res = await fetch('/vfr', {method: "GET", headers: {'Accept': 'application/vnd.api+json'
                            , 'x-access-token': getToken() }})
    const data = await res.json()
    console.log(data)
    return data
  }


  return(
      <div className='container'>
        <div className='test-name'>Incoming File Requests</div>
        <hr className='line-psy'></hr>


        <table className="table-wrapper-cross-y content-table">
          <thead>
          <tr>
            <th>Title</th>
            <th>View</th>
          </tr>
          </thead>

          <tbody>
          {
            responses.map(
                (response) => (
                    <tr>
                      <td>{response.title}</td>
                      {/* TODO: insert a l
                      ink to */}
                      <td><div className='response-text' onClick={() => navigate('/file_request/' + response.file_request_id)}>View Details</div></td><br/> <br/>
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