import React from 'react'
import "./LoginModal.css"
import {useState} from 'react'



const LoginModal = ({changeLoginModalFn, onLogin, onSignup, cngSignupModalFn, isSignUp, closeSignupModalFn}) => {

    const [isPatient, setIsPatient] = useState(true)

    const [email, setEmail] = useState('')
    const [password, setPassword] = useState('')

    const [personType, setPersonType] = useState("patient")
    const [gender, setGender] = useState("female")
    const [name, setName] = useState("")
    const [email_, setEmail_] = useState("")
    const [password_, setPassword_] = useState("")
    const [dob, setDob] = useState("")
    const [height, setHeight] = useState("")
    const [weight, setWeight] = useState("")
    const [location, setLocation] = useState("")
    const [certificateId, setCertificateId] = useState("")

    const onLoginSubmit = (e) => {
        e.preventDefault()

        if(!email){
            alert("Email should not be empty !!!")
            return
        }

        if(!password){
            alert("Password should not be empty !!!")
            return
        }

        onLogin({email, password})

        setEmail('')
        setPassword('')

        changeLoginModalFn()
    }

    const onSignUpSubmit = (e) => {
        e.preventDefault()

        if(!name){
            alert("Name should not be empty !!!")
            return
        }

        if(!email_){
            alert("Email should not be empty !!!")
            return
        }

        if(!password_){
            alert("Password should not be empty !!!")
            return
        }

        if(!dob){
            alert("Date of Birth should not be empty !!!")
            return
        } 
        
        if(isPatient){
            if(!height){
                alert("Height should not be empty !!!")
                return
            }
    
            if(!weight){
                alert("Weight should not be empty !!!")
                return
            }
    
            if(!location){
                alert("Location should not be empty !!!")
                return
            }
        }
        else{
            if(!certificateId){
                alert("Certificate No. should not be empty !!!")
                return
            }
        }

        onSignup({personType, name, email_, password_, dob, gender, height, weight, location, certificateId})
        setPersonType("patient")
        setIsPatient(true)
        setName("")
        setEmail_("")
        setPassword_("")
        setDob("")
        setGender("female")
        setHeight("")
        setWeight("")
        setLocation("")
        setCertificateId("")

        closeAll()
    }

    const closeAll = () => {
        closeSignupModalFn()
        setEmail('')
        setPassword('')
        changeLoginModalFn()

    }

    const changePersonType = (e) => {
        // console.log("Hello brother")
        setPersonType(e.target.value)

        setIsPatient(!isPatient)


    }



    return (
        
        <div>
            {   isSignUp ? 
                ( 
                    <div className='modal'> 
        

                        <form className='modal-content animate' onSubmit={onSignUpSubmit}>
                            <div className='imgcontainer'>
                                <span className="close" title="Close Modal" onClick={closeAll}>&times;</span>
                            </div>

                            <div className="login-container">
                                <div className='login-label'>SIGN UP</div><br />

                                <div className='input-field' ><label><b>Sign As</b></label></div>
                                <select value={personType} onChange={(e) => changePersonType(e)}>
                                    <option value="patient">Patient</option>
                                    <option value="psychiatrist">Psychiatrist</option>
                                </select>

                                <div className='input-field'><label><b>Name</b></label></div>
                                <input type="text" placeholder="Enter Name" value={name} onChange={(e) => setName(e.target.value)} />

                                <div className='input-field'><label><b>Email</b></label></div>
                                <input type="text" placeholder="Enter Email" value={email_} onChange={(e) => setEmail_(e.target.value)} />

                                <div className='input-field'><label><b>Password</b></label></div>
                                <input type="password" placeholder="Enter Password" value={password_} onChange={(e) => setPassword_(e.target.value)} />

                                <div className='input-field'><label><b>Gender</b></label></div>
                                <select value={gender} onChange={(e) => setGender(e.target.value)}>
                                    <option value="female">Female</option>
                                    <option value="male">Male</option>
                                    <option value="others">Others</option>
                                </select>

                                <div className='input-field'><label><b>Date of Birth</b></label></div>
                                <input type="text" placeholder="DD-MM-YYYY" value={dob} onChange={(e) => setDob(e.target.value)} />

                                
                                {isPatient ? 
                                    (
                                        <div>
                                            <div className='input-field'><label><b>Height &#40;inches&#41;</b></label></div>
                                            <input type="text" placeholder="Enter Height" value={height} onChange={(e) => setHeight(e.target.value)} />

                                            <div className='input-field'><label><b>Weight &#40;kgs&#41;</b></label></div>
                                            <input type="text" placeholder="Enter Weight" value={weight} onChange={(e) => setWeight(e.target.value)} />

                                            <div className='input-field'><label><b>Location</b></label></div>
                                            <input type="text" placeholder="Enter Location" value={location} onChange={(e) => setLocation(e.target.value)} />
                                        </div>
                                    ) :
                                    (
                                        <div>
                                            <div className='input-field'><label><b>Certificate No.</b></label></div>
                                            <input type="text" placeholder="Enter Certificate No." value={certificateId} onChange={(e) => setCertificateId(e.target.value)} />
                                        </div>
                                    )
                                }
                                

                

                                <input type="submit" className="login-btn-modal" value="Create" />

                                {/* <div className='open-acc'>
                                    <div className='open-acc1'>Don't Have an Account?</div>
                                    <div className='open-acc2' onClick={cngSignupModalFn}> <u>Create One</u> </div>
                                </div> */}
                                
                            </div>

                        </form>
                    </div>

                )   : 
                (
                    <div className='modal' onSubmit={onLoginSubmit}> 
        

                        <form className='modal-content animate'>
                            <div className='imgcontainer'>
                                <span className="close" title="Close Modal" onClick={changeLoginModalFn}>&times;</span>
                            </div>

                            <div className="login-container">
                                <div className='login-label'>LOGIN</div><br />
                                <div className='input-field'><label><b>Email</b></label></div>
                                <input type="text" placeholder="Enter Email" value={email} onChange={(e) => setEmail(e.target.value)} />

                                <div className='input-field'><label><b>Password</b></label></div>
                                <input type="password" placeholder="Enter Password" value={password} onChange={(e) => setPassword(e.target.value)} />

                                <input type="submit" className="login-btn-modal" value="Login" />

                                <div className='open-acc'>
                                    <div className='open-acc1'>Don't Have an Account?</div>
                                    <div className='open-acc2' onClick={cngSignupModalFn}> <u>Create One</u> </div>
                                </div>
                                
                            </div>

                        </form>
                    </div>
                ) 
            } 
        </div>
        
    )
}

export default LoginModal