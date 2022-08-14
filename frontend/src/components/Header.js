import React, {useState} from 'react'
import logo from './logo.png'
import './Header.css'
import {FaThumbsUp, FaThumbsDown, FaCheck, FaBan} from 'react-icons/fa'
import {getIdType, getUsername} from "./Variables";
import {useNavigate} from "react-router-dom";

const Header = ({changeLoginModalFn, loggedIn, cngLogoutModalFn}) => {
    const navigate = useNavigate();
    const [showNotificationModal, setShowNotificationModal] = useState(false)
    const [showRequestModal, setShowRequestModal] = useState(false)
    // const [requestList, setRequestList] = useState([])
    const [showNotoficationList, setShowNotificationList] = useState(false)


    const [requestList, setRequestList] = useState([])
    const [patientNotifications, setPatientNotifications] = useState([])

    //const [isPatient, setIsPatient] = useState(false)

    const notificationClicked = (type) => {
        if (type === "CR") {
            setShowNotificationModal(false)

            // const requests =
            fetchConsulationRequest().then((requests) => setRequestList(requests.consultation_requests))
            setShowRequestModal(true)
        }
    }


    const typeOfNotificationClicked = (type) => {
        if (type === "consultancyRequest") {
            setShowNotificationModal(false)

            // const requests = fetchConsulationRequest(id)

            const requests = [
                {"id": 1, "name": "Zaber", "time": "Sunday 8PM"},
                {"id": 2, "name": "Ifto", "time": "Sunday 8PM"},
                {"id": 3, "name": "Apurba", "time": "Sunday 8PM"},
                {"id": 4, "name": "Fahim", "time": "Sunday 8PM"}
            ]

            setRequestList(requests)
            setShowRequestModal(true)
        } else if (type === "reviewQuesUpdate") {
            console.log("Redirect to the page where update requests are listed")

        }
    }
    const patientConsultationButtonClicked = () => {
        if (getIdType() === 'patient_id') {
            fetchConsulationRequestPatient().then((notifications) => {
                console.log(notifications)
                setPatientNotifications(notifications.consultation_requests)
                setShowNotificationList(true)
            })
        } else {
            setShowNotificationModal(!showNotificationModal)
        }

    }

    const fetchConsulationRequest = async () => {
        const data = await fetch('/view_consultation_request', {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
                'x-access-token': localStorage.getItem('token')
            }
        }).then(res => res.json())
        //const data = await res.json()
        return data
    }

    const fetchConsulationRequestPatient = async () => {
        const data = await fetch('/consultation_requests', {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
                'x-access-token': localStorage.getItem('token')
            }
        }).then(res => res.json())
        //const data = await res.json()
        return data
    }


    const acceptConsultationRequest = async (id) => {
        const data = await fetch('/accept_consultation_request/' + id, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'x-access-token': localStorage.getItem('token')
            }
        }).then()
        fetchConsulationRequest() // refresh the list
    }

    const deleteConsultationRequest = async (id) => {
        const data = await fetch('/delete_consultation_request/' + id, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'x-access-token': localStorage.getItem('token')
            }
        }).then()
        fetchConsulationRequest() // refresh the list
        window.location.reload()
    }

    return (
        <>
            <div className='header'>
                <div style={{width: "30%"}}>
                    <img src={logo} className="header-logo" alt="logo"/>
                </div>

                <div style={{width: "40%"}}>
                    <nav>
                        <ul class="nav-links">
                            <li>Home</li>
                            <li>Trends and Statistics</li>
                            <li>About Us</li>
                        </ul>
                    </nav>
                </div>

                <div style={{width: "30%"}} className='header-right'>
                    {loggedIn ? (<div className='rad-box-name' onClick={cngLogoutModalFn}> {getUsername()}</div>) : (
                        <div className='login-btn' onClick={() => {
                            navigate('/login')
                        }}> Login</div>)}

                    {loggedIn ? (<div className='rad-box'
                                      onClick={() => setShowNotificationModal(!showNotificationModal)}>NOTIFICATION</div>) : (
                        <div className='rad-box' onClick={changeLoginModalFn}> TAKE A MENTAL HEALTH TEST</div>)}


                    {/*{loggedIn ? (<div className='rad-box' onClick={() => notificationButtonClicked() }>NOTIFICATION</div>) : (<div className='rad-box' onClick={changeLoginModalFn}> TAKE A MENTAL HEALTH TEST</div>)}*/}


                    {/*{loggedIn ? (<div className='rad-box'>NOTIFICATION</div>) : (<div className='rad-box' onClick={changeLoginModalFn}> TAKE A MENTAL HEALTH TEST</div>)}*/}
                </div>

            </div>


            {
                showNotificationModal && (
                    <div className='modal1'>
                        <div onClick={() => setShowNotificationModal(false)} className="overlay1"></div>

                        <div className="modal-content1">
                            <div className='detailContainer1'>
                                {!(getIdType() === 'patient_id') ? <>
                                    <hr className='line-psy' style={{width: "100%"}}></hr>
                                    <div className='task' onClick={() => notificationClicked("CR")}>
                                        Consultation Request
                                    </div>

                                    <hr className='line-psy' style={{width: "100%"}}></hr>
                                    <div className='task' onClick={() => typeOfNotificationClicked("reviewQuesUpdate")}>
                                        Review Questionnaire Update
                                    </div>

                                    <hr className='line-psy' style={{width: "100%"}}></hr>
                                    <div className='task'>
                                        Task 3
                                    </div>
                                    <hr className='line-psy' style={{width: "100%"}}></hr>
                                </> : <>
                                    <div className='task' onClick={() => patientConsultationButtonClicked()}>
                                        Check Approved Consultation Requests List
                                    </div>
                                    <hr className='line-psy' style={{width: "100%"}}></hr>
                                </>}
                            </div>

                        </div>
                    </div>
                )
            }

            {
                showRequestModal && (
                    <div className='modal1'>
                        <div onClick={() => setShowRequestModal(false)} className="overlay1"></div>

                        <div className="modal-content2">
                            <div className='detailContainer1'>
                                {
                                    console.log("Request list", requestList)}{
                                requestList.map(
                                    (request) => (
                                        request.approved ? (<> </>) :
                                            (<>
                                                <div className='requestItem'>
                                                    <div className='leftItem'>
                                                        {request.name} wanted to request consultancy at {request.time}
                                                    </div>

                                                    <div className='rightItem'>
                                                        <FaCheck className="icon1" style={{"margin-right": "25%"}}
                                                                 onClick={() => acceptConsultationRequest(request.id)}/>
                                                        <FaBan className="icon2"
                                                               onClick={() => deleteConsultationRequest(request.id)}/>
                                                    </div>

                                                </div>
                                                <hr className='line-psy' style={{width: "100%"}}></hr>
                                            </>)
                                    )
                                )
                            }
                            </div>

                        </div>
                    </div>
                )
            }

            {
                showNotoficationList && (
                    <div className='modal1'>
                        <div onClick={() => setShowNotificationList(false)} className="overlay1"></div>
                        <div className='modal-content2'>
                            <div className='detailContainer1'>
                                {
                                    patientNotifications.map(
                                        (notification) => (
                                            <>
                                                <div className='requestItem'>
                                                    {notification.text}
                                                </div>
                                                <hr className='line-psy' style={{width: "100%"}}></hr>
                                            </>
                                        )
                                    )
                                }
                            </div>
                        </div>
                    </div>
                )
            }
        </>

    )
}

export default Header