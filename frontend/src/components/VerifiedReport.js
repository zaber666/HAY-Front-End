import React from 'react'
import "./VerifiedReport.css"
import { useEffect, useState } from 'react'
import {FaAngleDown, FaAngleUp} from 'react-icons/fa'
import {getToken} from "./Variables";

const VerifiedReport = () => {

    const [expands, setExpands] = useState({});
    const [verifiedReports, setVerifiedReports] = useState([]);

    useEffect( () => {
        const getResponse = async () => {
            const verifiedFromServer = await fetchVerifiedReports()
            setVerifiedReports(verifiedFromServer.verified_reports)
            console.log("Report From Server" ,verifiedFromServer.verified_reports)

            var expandDict = {}
            verifiedFromServer.verified_reports.map(
                (report) => expandDict[report.reportId] = false
            );
            setExpands(expandDict);
            // console.log("expand dict", expandDict)
        }
        getResponse()

    }, [])
    const fetchVerifiedReports = async () => {
        const res = await fetch('http://localhost:5000/view_verified_report/',
                                {
                                    method: "GET",
                                    headers: {'Content-type': 'application/vnd.api+json', 'Accept': 'application/vnd.api+json'
                                    , 'x-access-token': getToken()}
                                })
        const data = await res.json()
        return data
    }

    const changeSpecificExpand = (id) => {
        var tempDict = {}
        for (const [key, value] of Object.entries(expands)){
            tempDict[key] = value
        }
        tempDict[id] = !tempDict[id];
        console.log("tempDict", tempDict);
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
                                    Your <div className='link'>test </div> {verifiedReport.test_name} submitted at {verifiedReport.submitted_at} has been verified by <b>{verifiedReport.psychiatrist}</b> <div style={{"marginLeft":"0.5%"}}></div> 
                                    </div>

                                    <div className='right'>
                                        <div className='rightElem' onClick={() => changeSpecificExpand(verifiedReport.reportId)}>
                                            {expands[verifiedReport.reportId] ?
                                                (<FaAngleUp/>) : (<FaAngleDown />)
                                            }
                                            
                                        </div>
                                    </div>
                                </div>
                                <span>On {verifiedReport.verified_at}</span>
                                

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
                                                            (suggPsy) => <li>{suggPsy.name}</li>
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

export default VerifiedReport