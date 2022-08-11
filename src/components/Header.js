import React, { useState } from 'react'
import logo from './logo.png'
import './Header.css'
import {FaThumbsUp, FaThumbsDown, FaCheck, FaBan} from 'react-icons/fa'

const Header = ({changeLoginModalFn, loggedIn, cngLogoutModalFn}) => {

    const [showNotificationModal, setShowNotificationModal] = useState(false)
    const [showRequestModal, setShowRequestModal] = useState(false)
    const [requestList, setRequestList] = useState([])

    const notificationClicked = (type) => {
        if (type === "CR"){
            setShowNotificationModal(false)

            // const requests = fetchConsulationRequest(id)
            
            const requests = [
                {"id":1, "name":"Zaber", "time":"Sunday 8PM"},
                {"id":2, "name":"Ifto", "time":"Sunday 8PM"},
                {"id":3, "name":"Apurba", "time":"Sunday 8PM"},
                {"id":4, "name":"Fahim", "time":"Sunday 8PM"}
            ]

            setRequestList(requests)
            setShowRequestModal(true)
        }
    }

    const fetchConsulationRequest = async (id) => {
        const res = await fetch(`http://localhost:8000/psychiatrists_details/${id}`)
        const data = await res.json()
        return data
    }

    return (
        <>
            <div className='header'>
                <div style={{width: "30%"}}>
                    <img src={logo} className="header-logo" alt="logo" />
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
                    {loggedIn ? (<div className='rad-box-name' onClick={cngLogoutModalFn}> Zaber</div>) : (<div className='login-btn' onClick={changeLoginModalFn}> Login</div>)}
                    
                    {loggedIn ? (<div className='rad-box' onClick={() => setShowNotificationModal(!showNotificationModal)}>NOTIFICATION</div>) : (<div className='rad-box' onClick={changeLoginModalFn}> TAKE A MENTAL HEALTH TEST</div>)}
                </div>

            </div>



            {
                showNotificationModal && (
                    <div className='modal1'>
                        <div onClick={() => setShowNotificationModal(false)} className="overlay1"></div>

                        <div className="modal-content1">
                            <div className='detailContainer1'>

                                <hr className='line-psy' style={{width:"100%"}}></hr>
                                <div className='task' onClick={() => notificationClicked("CR")}>
                                    Consultation Request
                                </div>

                                <hr className='line-psy' style={{width:"100%"}}></hr>
                                <div className='task'>
                                    Task 2
                                </div>

                                <hr className='line-psy' style={{width:"100%"}}></hr>
                                <div className='task'>
                                    Task 3
                                </div>
                                <hr className='line-psy' style={{width:"100%"}}></hr>
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
                                    requestList.map(
                                        (request) => (
                                            <>
                                                <div className='requestItem'>
                                                    <div className='leftItem'>
                                                        {request.name} wanted to request consultancy at {request.time}
                                                    </div>

                                                    <div className='rightItem'>
                                                        <FaCheck className="icon1" style={{"margin-right":"25%"}}/>
                                                        <FaBan className="icon2" />
                                                    </div>

                                                </div>
                                                <hr className='line-psy' style={{width:"100%"}}></hr>
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