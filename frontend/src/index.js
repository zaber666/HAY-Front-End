import React, {useState, useEffect} from 'react';
import ReactDOM from 'react-dom';

const restEndpoint = "/api/persons/1705002";

const callRestApi = async () => {
    const response = await fetch(restEndpoint, {method: "GET", headers: {'Accept': 'application/vnd.api+json'}});
    const jsonResponse = await response.json();
    console.log(jsonResponse);
    return JSON.stringify(jsonResponse);
};

function RenderResult() {
    const [apiResponse, setApiResponse] = useState("*** now loading ***");

    useEffect(() => {
        callRestApi().then(
            result => setApiResponse(result));
    }, []);

    return (
        <div>
            <h1>React App</h1>
            <p>{apiResponse}</p>
        </div>
    );
};

ReactDOM.render(
    <div>
        <RenderResult />
        <img src={"https:picsum.photos/500/300"} alt=""/></div>,
    document.querySelector('#root')
);
