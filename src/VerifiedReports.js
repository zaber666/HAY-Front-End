import React from 'react'
import "./VerifiedReports.css"
import { useEffect, useState } from 'react'
import {FaAngleDown, FaAngleUp} from 'react-icons/fa'


const VerifiedReports = () => {

    const [expands, setExpands] = useState({});
    const [verifiedReports, setVerifiedReports] = useState([]);

    useEffect( () => {
        const getResponse = async () => {
            const verifiedFromServer = await fetchVerifiedReports()
            setVerifiedReports(verifiedFromServer)

            var expandDict = {}
            verifiedFromServer.map(
                (report) => expandDict[report.reportId] = false
            );
            setExpands(expandDict);
        }
        getResponse()

    }, [])
    const fetchVerifiedReports = async () => {
        const res = await fetch('http://localhost:8000/verifiedReports')
        const data = await res.json()
        return data
    }

    const changeSpecificExpand = (id) => {
        var tempDict = {}
        for (const [key, value] of Object.entries(expands)){
            tempDict[key] = value
        }
        tempDict[id] = !tempDict[id];
        setExpands(tempDict);
    }

    return (
        <div className='container'>
            <h2>Verified Reports</h2>
            <hr className='line-psy' style={{width:"70%"}}></hr>

            {
                verifiedReports.map(
                    (verifiedReport) => (
                        <div>
                            <div className="review-card">
                                <div className='title'>
                                    <div className='left'>
                                        <b>{verifiedReport.psychiatrist}</b> <div style={{"marginLeft":"0.5%"}}></div> reviewed your <div className='link'> report </div>
                                    </div>

                                    <div className='right'>
                                        <div className='rightElem' onClick={() => changeSpecificExpand(verifiedReport.reportId)}>
                                            {expands[verifiedReport.reportId] ?
                                                (<FaAngleUp/>) : (<FaAngleDown />)
                                            }
                                            
                                        </div>
                                    </div>
                                </div>
                                <span>On {verifiedReport.time}</span>
                                

                                {expands[verifiedReport.reportId] ?
                                    (
                                        <div>
                                            <br /><br />
                                            <b>Initial query result:</b>
                                            <div style={{"margin-left":"3%"}}>{verifiedReport.systemScore}</div><br />

                                            <b>Suggestions:</b>
                                            <div style={{"margin-left":"3%", "word-wrap":"break-word"}}>{verifiedReport.sugesstions}</div><br />
                                                
                                            <b>Suggested Psychiatrists:</b>
                                            <div >
                                                <ul >
                                                    
                                                    {
                                                        verifiedReport.suggestedPsychiatrists.map(
                                                            (suggPsy) => <li>{suggPsy}</li>
                                                        )
                                                    }

                                                </ul>
                                            </div>
                                        </div>
                                    ) : (<></>)
                                }
                
                            </div>
                        </div>
                    )
                )
            }

            

        </div>
    )
}

export default VerifiedReports