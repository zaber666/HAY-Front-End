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


  

  return (
    
    <div>
      <Header changeLoginModalFn={() => changeLoginModal(true)} loggedIn={userLoggedIn} cngLogoutModalFn={() => changeLogoutModal(true)}  />
      
      {userLoggedIn ? (<Tests />) : (<Talks changeModalFn={() => changeLoginModal(true)} />)}

      {showLoginModal && <LoginModal changeLoginModalFn={() => changeLoginModal(false)} cngSignupModalFn={() => changeSignupModal(true)} closeSignupModalFn={() => changeSignupModal(false)} isSignUp={signupModal}  />}
      
      {showLogoutModal && <LogoutModal cngLogoutModalFn={() => changeLogoutModal(false)}/>}

      {/* <PsyHome /> */}

      {/* <Questions /> */}
      
      <Footer />
    </div>
  );
}

export default App;
