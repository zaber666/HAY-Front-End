import React from 'react'
import "./Tests.css"
import {useNavigate} from "react-router-dom";

const PsyHome = () => {

    const navigate = useNavigate()

    return (
        <div className='tests-body'>
            <div className='test-name' onClick={() => navigate('/pending_test_results')}>Patient Scores And Responses</div>
            <hr className='line-psy'></hr>
            <div className='test-name'>Update Questionnaire</div>
            <hr className='line-psy'></hr>
            <div className='test-name'>Request File From Patients</div>
            <hr className='line-psy'></hr>
        </div>
    )
}

export default PsyHome