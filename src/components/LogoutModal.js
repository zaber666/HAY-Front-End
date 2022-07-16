import React from 'react'
import "./LoginModal.css"
import {clearAll} from "./Variables";

const LogoutModal = ({cngLogoutModalFn}) => {

    return (
        <div className='modal'>
            <form className='modal-content animate'>
                <div className='imgcontainer'>
                    <span className="close" title="Close Modal" onClick={cngLogoutModalFn}>&times;</span>
                </div>
                <div className="login-container">
                    <input type="submit" className="login-btn-modal" value="Logout" onClick={clearAll} />
                </div>

            </form>
        </div>
    )
}

export default LogoutModal