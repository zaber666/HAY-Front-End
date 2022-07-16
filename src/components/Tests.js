import React from 'react'
import "./Tests.css"
import { useState, useEffect } from 'react'


const Tests = () => {

    const [specificTests, setSpecificTests] = useState([])

    useEffect( () => {
        const getTests = async () => {
        const testsFromServer = await fetchTests()
        setSpecificTests(testsFromServer)
        }

        getTests()
    }, [])

    //Fetch Tasks
    const fetchTests = async () => {
        const res = await fetch('http://localhost:8000/specificTests')
        const data = await res.json()
        return data
    }


    return (
        <div className='tests-body'>
            <span className='topic-header'>General Questionnaire</span>
            <hr className='line'></hr>
            <div className="test-name">Self-Rated Level 1 Cross-Cutting Symptom Measure</div>
            <div class="test-desc">Are you experiencing the most common symptoms of autism? Find out using our Autism tests.</div>


            <div className='topic-header spaced'>Specific Questionnaire</div>
            <hr className='line'></hr>

            {
                specificTests.map(
                    (test) => (
                        <>
                            <div className="test-name">{test.testName}</div>
                            <div class="test-desc">{test.description}</div>
                        </>
                    )
                )
            }
            
        </div>
    )
}

export default Tests