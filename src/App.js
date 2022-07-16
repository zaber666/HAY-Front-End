import logo from './logo.svg';
import './App.css';
import {getPersonId, getIdType, getUsername, clearAll} from './components/Variables.js';
import Header from './components/Header';
import Talks from './components/Talks';
import Footer from './components/Footer';
import LoginModal from './components/LoginModal';
import {useState, useEffect} from "react";
import LogoutModal from './components/LogoutModal';
import Tests from './components/Tests';
import { useCookies, Cookies, withCookies} from "react-cookie";
import PsyHome from './components/PsyHome';
import Questions from './components/Questions';
import {ListQuestionsOfATest} from "./components/Questionnaire";

function App() {

  const userLoggedIn = false;
  const [showLoginModal, changeLoginModal] = useState(false);
  const [showLogoutModal, changeLogoutModal] = useState(false);
  const [signupModal, changeSignupModal] = useState(false);

  const [cookies, setCookie, removeCookie] = useCookies(['user']);


  return (


    <div>
      <Header changeLoginModalFn={() => changeLoginModal(true)} loggedIn={(getPersonId() !== '')} cngLogoutModalFn={() => changeLogoutModal(true)}  />
      
      {(getPersonId() !== '') ? (<Tests />) : (<Talks changeModalFn={() => changeLoginModal(true)} />
      )}

        {/*<button onClick={() => setCookie('Name', getUsername(), {path : '/'})}> Cookie </button>*/}
        {/*<button onClick={() => removeCookie('Name')}> Remove Cookie </button>*/}
        {/*<button onClick={() => console.log(cookies.get('Name'))}> Print </button>*/}

      {showLoginModal && <LoginModal changeLoginModalFn={() => changeLoginModal(false)} cngSignupModalFn={() => changeSignupModal(true)} closeSignupModalFn={() => changeSignupModal(false)} isSignUp={signupModal}  />}
      
      {showLogoutModal && <LogoutModal cngLogoutModalFn={() => changeLogoutModal(false)}/>}

      {/*{ <PsyHome /> }*/}

      {/* <Questions /> */}

        {/*{<ListQuestionsOfATest testId={2}/>}*/}
      
      <Footer />
    </div>
  );
}

export default App;
