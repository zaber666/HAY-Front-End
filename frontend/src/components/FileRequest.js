import React from 'react'
import {clearAll} from "./Variables";
import {useNavigate} from "react-router-dom";

import 'bootstrap/dist/css/bootstrap.min.css';
import "./FileRequest.css";

export function CreateFileRequest() {

    const [title, setTitle] = React.useState("");
    const [desc, setDesc] = React.useState("");

    const submit = async (title, desc) => {
        console.log("Just in submit", title, desc);
        const res = await fetch('http://localhost:5000/cfr',
            {
                method: "POST",
                headers: {
                    'Content-type': 'application/vnd.api+json'
                    , 'Accept': 'application/vnd.api+json'
                },
                body: JSON.stringify({
                    'title' : title, 'desc' : desc
                })
            }
        );
        console.log(res)
    }

    return (
        <div className="reqForm">
            <form onSubmit={() => {submit(title, desc)}}>
                <div className="form-group">
                    <label htmlFor="exampleInputEmail1">Request Title</label>
                    <input type="text" className="form-control" id="exampleInputEmail1" aria-describedby="emailHelp"
                           placeholder="Title" onChange={(e) => setTitle(e.target.value)}/>
                </div>
                <br/><br/>
                <div className="form-group">
                    <label htmlFor="exampleInputPassword1">Request Description</label>
                    <input type="text" className="form-control" id="exampleInputPassword1" placeholder="Please detail out what you need"
                     onChange={(e) => setDesc(e.target.value)}/>
                </div>
                <br/>
                <div className="form-check">
                    <input type="checkbox" className="form-check-input" id="exampleCheck1"/>
                    <label className="form-check-label" htmlFor="exampleCheck1">I agree to the terms and conditions.</label>
                </div>
                <button type="submit" className="btn btn-primary">Submit</button>
            </form>
        </div>
    );
}
