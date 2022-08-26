import React, {useEffect} from 'react'
import styles from "./newCss/Tests.module.css"
import {useNavigate} from "react-router-dom";

const PsyHome = () => {

    const navigate = useNavigate()

    //const [isReviewer, setIsReviewer] = useState(false)


    return (
        <div className={styles.testsBody}>
            <span className={styles.testName} onClick={() => navigate('/pending_test_results')}>Patient Scores And Responses</span>
            <hr className={styles.linePsy}></hr>
            <span className={styles.testName} onClick={() => navigate('/ptests')}>Update Questionnaire</span>
            <hr className={styles.linePsy}></hr>
            <span className={styles.testName} onClick={() => navigate('/create_file_request')}>Request File From Patients</span>
            <hr className={styles.linePsy}></hr>

            <span className={styles.testName} onClick={() => navigate('/')}>Pending Colsultation Request</span>
            <hr className={styles.linePsy}></hr>

            <span className={styles.testName} onClick={() => navigate('/')}>Review Questionnaire Update Request</span>
            <hr className={styles.linePsy}></hr>
        </div>
    )
}

export default PsyHome