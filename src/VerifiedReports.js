import React from 'react'
import "./VerifiedReports.css"
import { useEffect, useState } from 'react'
import {FaAngleDown, FaAngleUp} from 'react-icons/fa'
import image from "./components/doctor.jpg"


const VerifiedReports = () => {

    const [expands, setExpands] = useState({});
    const [verifiedReports, setVerifiedReports] = useState([]);
    const [showModal, setShowModal] = useState(false);
    const [psyDetail, setPsyDetail] = useState({});
    const [time, setTime] = useState("")

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

    const psyClicked = (id) =>{
        // const details = fetchPsychiatristDetails(id)

        const details = {
            "id":1,
            "name":"MA. Adnan Rahman",
            "designation": "Cancer Specialist",
            "cell": 42042069,
            "email": "johndoe@gmail.com",
            "area_of_expertise":[
              "cancer", "skin", "bone"
            ],
            "awards": [
              "some random award",
              "random award with too big name random award with too big name random award with too big name"
            ],
            "available_hours" : [
              {"id":1, "datetime":"Monday 6pm - 8pm"},
              {"id":2, "datetime":"Tuesday 7pm - 10pm"},
              {"id":3, "datetime":"Wednesday 6pm - 8pm"},
              {"id":4, "datetime":"Friday 5pm - 9pm"}
            ]
        }
        
        setPsyDetail(details)
        setShowModal(true)
    }

    const fetchPsychiatristDetails = async (id) => {
        const res = await fetch(`http://localhost:8000/psychiatrists_details/${id}`)
        const data = await res.json()
        return data
    }
    const requestTime = (e) => {
        e.preventDefault()

        if (!time){
            alert("Fill Atleast One Time")
            return
        }

        console.log(time)

        setTime("")
    }

    return (
        <>
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
                                                                (suggPsy) => <li><span className='docName' onClick={() => psyClicked(suggPsy.id)}>{suggPsy.name}</span></li>
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

            {
                showModal && (
                    <div className='modal'>
                        <div onClick={() => setShowModal(false)} className="overlay"></div>

                        <div className="modal-content">
                            <div className='detailContainer'>
                                <div className='docNameModal'>{psyDetail.name}</div>
                                <hr className='line-psy' style={{width:"70%"}}></hr>

                                <div className='flexbox'>
                                    <div className='leftFlex'>
                                        <img src={image} />
                                        <div className='designation'>{psyDetail.designation}</div>
                                        <div className='cell'>Cell:  {psyDetail.cell}</div>
                                        <div className='cell'>Email:  {psyDetail.email}</div>
                                    </div>

                                    <div className='middleFlex'>
                                    </div>

                                    <div className='rightFlex'>
                                        <b>AREAS OF EXPERTISE</b>
                                        <hr className='line-psy' style={{width:"90%"}}></hr>
                                        <ul>
                                            {
                                                psyDetail.area_of_expertise.map(
                                                    (area) => <li className='cell'>{area}</li>
                                                )
                                            }
                                        </ul>

                                        <b>HONORS and AWARDS</b>
                                        <hr className='line-psy' style={{width:"90%"}}></hr>
                                        <ul>
                                            {
                                                psyDetail.awards.map(
                                                    (award) => <li className='cell'>{award}</li>
                                                )
                                            }
                                        </ul>


                                        <b>Available Hours</b>
                                        <hr className='line-psy' style={{width:"90%"}}></hr>
                                        <form onSubmit={requestTime}>
                                            {
                                                psyDetail.available_hours.map(
                                                    (available) => (
                                                        <div className='optionContainer' onChange={(e) => setTime(e.target.value)}>
                                                            <input type="radio" className='radio' name="selectTime" value={available.datetime} ></input>
                                                            
                                                            <div>{available.datetime}</div>
                                                        </div>  
                                                    )
                                                )
                                            }
                                            <button type="submit" className="btn-btn">Send </button>
                                        </form>
                                    </div>
                                </div>
                            </div>



                            <button className="close-modal" onClick={() => setShowModal(false)}>
                            CLOSE
                            </button>
                        </div>
                    </div>
                )
            }



        </>
    )
}

export default VerifiedReports