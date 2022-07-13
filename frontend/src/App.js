import React, { Component } from 'react';
import logo from './logo.svg';
import './App.css';
import Counter, {Counter2, ShowPerson} from "./components/counter";

class App extends Component {


  render() {
    return (
      <div className="App">
        <div className="App-header">
          <img src={logo} className="App-logo" alt="logo" />
          <h2>Welcome to React</h2>
        </div>
        <p className="App-intro">
          To get started, edit <code>src/App.js</code> and save to reload.
        </p>
          <button onClick={() => fetch('/api/persons/1705002', {
               method: 'get',
               headers: new Headers(
                 // Your header content
                   {'Content-Type': 'application/vnd.api+json', 'Accept': 'application/vnd.api+json'}
               )
             })}> Do </button>
          <br/>
          <br/>
          <Counter2/>
          <ShowPerson/>
      </div>
    );
  }
}

export default App;
