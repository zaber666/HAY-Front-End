import React from 'react'
import logo from './logo.png'
import './Header.css'
import {getUsername} from "./Variables";
import {useNavigate} from "react-router-dom";

const Header = ({changeLoginModalFn, loggedIn, cngLogoutModalFn}) => {

    const navigate = useNavigate();

    return (
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
                {loggedIn ? (<div className='rad-box-name' onClick={cngLogoutModalFn}> {getUsername()}</div>) : (<div className='login-btn' onClick={() => {navigate('/login')}}> Login</div>)}
                
                {loggedIn ? (<div className='rad-box'>NOTIFICATION</div>) : (<div className='rad-box' onClick={changeLoginModalFn}> TAKE A MENTAL HEALTH TEST</div>)}
            </div>

        </div>
    )
}

export default Header