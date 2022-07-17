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
import {useCookies, Cookies, withCookies} from "react-cookie";
import {BrowserRouter as Router, Route, Routes, Switch, useParams} from 'react-router-dom'
import PsyHome from './components/PsyHome';
import Questions from './components/Questions';
import {ListQuestionsOfATest} from "./components/Questionnaire";

function App() {

    const userLoggedIn = false;
    const [showLoginModal, changeLoginModal] = useState(false);
    const [showLogoutModal, changeLogoutModal] = useState(false);
    const [signupModal, changeSignupModal] = useState(false);

    const [cookies, setCookie, removeCookie] = useCookies(['user']);

    function RenderTest() {
        return <ListQuestionsOfATest testId={useParams().testId}/>
    }

    return (

        <Router>
            <div>
                <Header changeLoginModalFn={() => changeLoginModal(true)} loggedIn={(getPersonId() !== '')}
                        cngLogoutModalFn={() => changeLogoutModal(true)}/>

                <Routes>

                    <Route path="/login" element={<LoginModal changeLoginModalFn={() => changeLoginModal(false)}
                                                         cngSignupModalFn={() => changeSignupModal(true)}
                                                         closeSignupModalFn={() => changeSignupModal(false)}
                                                         isSignUp={signupModal}/>}/>

                    <Route path="/logout" element={<LogoutModal changeLogoutModalFn={() => changeLogoutModal(false)}/>}/>

                    <Route path="/tests" element={<Tests/>}/>
                    <Route path="/tests/:testId" element={<RenderTest/>} />
                    <Route path="/psyhome" element={<PsyHome/>}/>
                    <Route path="/questions" element={<Questions/>}/>
                    <Route path={"/"} element=<Talks changeModalFn={() => changeLoginModal(true)}/> />

                </Routes>

                <Footer/>
            </div>
        </Router>
    );
}

export default App;
