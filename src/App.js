import logo from './logo.svg';
import './App.css';
import Header from './components/Header';
import Talks from './components/Talks';
import Footer from './components/Footer';
import LoginModal from './components/LoginModal';
import {useState, useEffect} from "react";
import LogoutModal from './components/LogoutModal';
import Tests from './components/Tests';
import PsyHome from './components/PsyHome';
import Questions from './components/Questions';

function App() {

  const userLoggedIn = false;
  const [showLoginModal, changeLoginModal] = useState(false);
  const [showLogoutModal, changeLogoutModal] = useState(false);
  const [signupModal, changeSignupModal] = useState(false);

  // POST Request for login
  const promptLogin = async (loginInfo) => {
    const res = await fetch('http://localhost:8000/login-info', 
      {
        method: "POST", 
        headers: {'Content-type': 'application/json'}, 
        body: JSON.stringify(loginInfo)
      }
    )
    const data = await res.json()
  }

  // POST request for sign up
  const promptSignup = async (signupInfo) => {
    const res = await fetch('http://localhost:8000/signup-info', 
      {
        method: "POST", 
        headers: {'Content-type': 'application/json'}, 
        body: JSON.stringify(signupInfo)
      }
    )
    const data = await res.json()
  }


  const [specificTests, changeSpecificTests] = useState([
    {
      id : 1,
      testName : "OCD Test",
      description : "Suffering from obsessive thoughts of compulsive behavior? Take a tour to our OCD tests."
    },
    {
      id : 2,
      testName : "PTSD Test",
      description : "Any horrible course of events that are still terrifying you? Find out through our PTSD tests."
    }
  ])

  return (
    
    <div>
      <Header changeLoginModalFn={() => changeLoginModal(true)} loggedIn={userLoggedIn} cngLogoutModalFn={() => changeLogoutModal(true)}  />
      
      {/* {userLoggedIn ? (<Tests tests={specificTests} />) : (<Talks changeModalFn={() => changeLoginModal(true)} />)}

      {showLoginModal && <LoginModal onSignup={promptSignup} onLogin={promptLogin} changeLoginModalFn={() => changeLoginModal(false)} cngSignupModalFn={() => changeSignupModal(true)} closeSignupModalFn={() => changeSignupModal(false)} isSignUp={signupModal}  />}

      {showLogoutModal && <LogoutModal cngLogoutModalFn={() => changeLogoutModal(false)}/>} */}

      {/* <PsyHome /> */}

      <Questions />
      
      <Footer />
    </div>
  );
}

export default App;
