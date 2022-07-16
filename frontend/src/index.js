import React, {useEffect, useState} from 'react';
import ReactDOM from 'react-dom';
import {ListQuestionsOfATest} from "./components/Questionnaire";
import App from "./App";

ReactDOM.render(
    <div>
            <App/>
        {/*<img src={"https:picsum.photos/500/300"} alt=""/>*/}
    </div>,
    document.querySelector('#root')
);
