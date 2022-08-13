import React, {useEffect} from 'react'
import "./Tests.css"
import {useNavigate} from "react-router-dom";

const PsyHome = () => {

    const navigate = useNavigate()

    //const [isReviewer, setIsReviewer] = useState(false)


    return (
        <div className='tests-body'>
            <div className='test-name' onClick={() => navigate('/pending_test_results')}>Patient Scores And Responses</div>
            <hr className='line-psy'></hr>
            <div className='test-name' onClick={() => navigate('/ptests')}>Update Questionnaire</div>
            <hr className='line-psy'></hr>
            <div className='test-name' onClick={() => navigate('/create_file_request')}>Request File From Patients</div>
            <hr className='line-psy'></hr>
        </div>
    )
}

export default PsyHome