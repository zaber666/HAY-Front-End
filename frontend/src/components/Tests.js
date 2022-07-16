import React from 'react'
import "./Tests.css"
import Test from './Test'


const Tests = ({tests}) => {
    return (
        <div className='tests-body'>
            <span className='topic-header'>General Questionnaire</span>
            <hr className='line'></hr>
            <div className="test-name">Self-Rated Level 1 Cross-Cutting Symptom Measure</div>
            <div class="test-desc">Are you experiencing the most common symptoms of autism? Find out using our Autism tests.</div>


            <div className='topic-header spaced'>Specific Questionnaire</div>
            <hr className='line'></hr>

            {tests.map( (test) => (<Test key={test.id} test={test.testName} description={test.description} />))}
        </div>
    )
}

export default Tests