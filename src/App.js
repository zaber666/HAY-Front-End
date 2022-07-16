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

function App() {

  const userLoggedIn = false;
  const [showLoginModal, changeLoginModal] = useState(false);
  const [showLogoutModal, changeLogoutModal] = useState(false);
  const [signupModal, changeSignupModal] = useState(false);




  // return (
  //   <Router>
  //     <div >
  //       <Header changeLoginModalFn={() => changeLoginModal(true)} loggedIn={userLoggedIn} cngLogoutModalFn={() => changeLogoutModal(true)}  />


  //       <Routes>
          
  //         <Route path="signIn" element={} />

  //         <Route path="/about" element={<About/>} />
          
  //         <Route path="/" element={
  //           <div> 
  //             {showAddTask && <AddTask onAdd={addTask}/>} 
  //             { tasks.length > 0 ? (<Tasks tasks={tasks} onDelete={deleteTask} onToggle={toggleReminder} />) : "No Task to Show" } 
  //           </div>
  //         } />

  //       </Routes>

  //       <Footer />
  //     </div>
  //   </Router>
  // );
  
  //////////////////////////////////////////////////////////////////////
  //////////////// Previous Return ///////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  return (
    
    <div>
      <Header changeLoginModalFn={() => changeLoginModal(true)} loggedIn={userLoggedIn} cngLogoutModalFn={() => changeLogoutModal(true)}  />
      
      {/* {userLoggedIn ? (<Tests />) : (<Talks changeModalFn={() => changeLoginModal(true)} />)}

      {showLoginModal && <LoginModal changeLoginModalFn={() => changeLoginModal(false)} cngSignupModalFn={() => changeSignupModal(true)} closeSignupModalFn={() => changeSignupModal(false)} isSignUp={signupModal}  />}

      {showLogoutModal && <LogoutModal cngLogoutModalFn={() => changeLogoutModal(false)}/>} */}

      {/* <PsyHome /> */}

      {/* <Questions /> */}

      {/* <ScoreNDResponse /> */}

      <ShowResponse />
      
      <Footer />
    </div>
  );
}

export default App;
