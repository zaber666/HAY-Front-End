import logo from './logo.svg';
import './App.css';
import Header from './components/Header';
import Talks from './components/Talks';
import Footer from './components/Footer';
import LoginModal from './components/LoginModal';
import {useState, useEffect} from "react";
import {BrowserRouter as Router, Route, Routes} from 'react-router-dom'
import LogoutModal from './components/LogoutModal';
import Tests from './components/Tests';
import PsyHome from './components/PsyHome';
import Questions from './components/Questions';
import ScoreNDResponse from './components/ScoreNDResponse';
import ShowResponse from './components/ShowResponse';
import VerifiedReports from './VerifiedReports';
import AddOrDeleteQues from './components/AddOrDeleteQues';
import AddQuestion from './components/AddQuestion';
import ListQuesUpdates from './components/ListQuesUpdates';
import DetailedQuesRequest from './components/DetailedQuesRequest';

function App() {

  const userLoggedIn = true;
  const [showLoginModal, changeLoginModal] = useState(false);
  const [showLogoutModal, changeLogoutModal] = useState(false);
  const [signupModal, changeSignupModal] = useState(false);




  return (
    <Router>
      <div >
        <Header changeLoginModalFn={() => changeLoginModal(true)} loggedIn={userLoggedIn} cngLogoutModalFn={() => changeLogoutModal(true)}  />


        <Routes>
          
          <Route path="signIn" element={
            <LoginModal changeLoginModalFn={() => changeLoginModal(false)} cngSignupModalFn={() => changeSignupModal(true)} closeSignupModalFn={() => changeSignupModal(false)} isSignUp={signupModal}  />
          } />

          <Route path="closeSigning" element={
            <LogoutModal cngLogoutModalFn={() => changeLogoutModal(false)}/>
          } />

          <Route path="" element={
            // <Talks changeModalFn={() => changeLoginModal(true)} />
            // <ShowResponse />
            // <VerifiedReports />
            // <AddOrDeleteQues />
            // <AddQuestion />
            // <ListQuesUpdates />
            <DetailedQuesRequest />
          } />

          <Route path="tests" element={
            <Tests />
          } />

          <Route path="psyHome" element={
            <PsyHome />
          } />

          <Route path="questionnaire" element={
            <Questions />
          } />

          <Route path="update_questionnaire" element={
            <Tests />
          } />

          

        </Routes>

        <Footer />
      </div>
    </Router>
  );
  
  //////////////////////////////////////////////////////////////////////
  //////////////// Previous Return ///////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  // return (
    
  //   <div>
  //     <Header changeLoginModalFn={() => changeLoginModal(true)} loggedIn={userLoggedIn} cngLogoutModalFn={() => changeLogoutModal(true)}  />
      
  //     {/* {userLoggedIn ? (<Tests />) : (<Talks changeModalFn={() => changeLoginModal(true)} />)}

  //     {showLoginModal && <LoginModal changeLoginModalFn={() => changeLoginModal(false)} cngSignupModalFn={() => changeSignupModal(true)} closeSignupModalFn={() => changeSignupModal(false)} isSignUp={signupModal}  />}

  //     {showLogoutModal && <LogoutModal cngLogoutModalFn={() => changeLogoutModal(false)}/>} */}

  //     {/* <PsyHome /> */}

  //     {/* <Questions /> */}

  //     {/* <ScoreNDResponse /> */}

  //     <ShowResponse />
      
  //     <Footer />
  //   </div>
  // );
}

export default App;
