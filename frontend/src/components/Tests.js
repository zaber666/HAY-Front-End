import React from 'react'
import "./Tests.css"
import { useState, useEffect } from 'react'
import {useNavigate} from "react-router-dom";
import {getToken} from "./Variables";


const Tests = () => {

    const [specificTests, setSpecificTests] = useState([])
    const navigate = useNavigate();

    useEffect( () => {
        const getTests = async () => {
        const testsFromServer = await fetchTests()
        console.log('Tests from server', testsFromServer)
        setSpecificTests(testsFromServer)
        }

        getTests()
    }, [])

    //Fetch Tasks
    const fetchTests = async () => {
        const res = await fetch('/api/tests',
            {
                method: "GET",
                headers: {'Content-type': 'application/vnd.api+json', 'Accept': 'application/vnd.api+json'
                , 'x-access-token': getToken()}
            })
        const data = await res.json()
        console.log('Data: ', data)
        if (typeof data.data === 'undefined'){
            console.log('Returning empty ')
            return []
        }
        console.log('Data.data: ', data.data)
        return data.data
    }


    return (
        <div className='tests-body'>
            {/*<span className='topic-header'>General Questionnaire</span>*/}
            {/*<hr className='line'></hr>*/}
            {/*<div className="test-name">Self-Rated Level 1 Cross-Cutting Symptom Measure</div>*/}
            {/*<div class="test-desc">Are you experiencing the most common symptoms of autism? Find out using our Autism tests.</div>*/}


            <div className='topic-header spaced'>Specific Questionnaire</div>
            <hr className='line'></hr>

            { console.log(specificTests)}
            { (specificTests.length == 0) ? <h3>Not logged in as patient</h3> :
            <div>{
                specificTests.map(
                    (test) => (
                        <div>
                            {console.log(test.attributes.test_id)}
                            <div className="test-name" onClick={() => navigate("/tests/" + test.attributes.test_id)}>{test.attributes.name}</div>
                            <div class="test-desc">{test.attributes.description}</div>
                        </div>
                    )
                )
            }
            </div>
            }

        </div>
    )
}

export default Tests
