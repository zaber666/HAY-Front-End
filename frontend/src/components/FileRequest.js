import React from 'react'
import "./FileRequest.css";
import {useNavigate} from "react-router-dom";
import {getToken} from "./Variables";

export function CreateFileRequest() {

    const [title, setTitle] = React.useState("");
    const [desc, setDesc] = React.useState("");
    const navigate = useNavigate();

    const submit = async (title, desc) => {
        console.log("Just in submit", title, desc);
        const res = await fetch('http://localhost:5000/cfr',
            {
                method: "POST",
                headers: {
                    'Content-type': 'application/vnd.api+json'
                    , 'Accept': 'application/vnd.api+json'
                    , 'x-access-token': getToken()
                },
                body: JSON.stringify({
                    'title' : title, 'desc' : desc
                })
            }
        );
        return res;
    }

    return (
        <div className="reqForm">
            <form onSubmit={(e) => {e.preventDefault(); submit(title, desc).then(
                (response) => {
                    if(response.ok) {
                        alert("Thanks for uploading the file request. It will be checked by review board members.");
                        navigate('/psyhome');
                    } else {
                        alert("Please try again");
                    }
                }
            );}}>
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
                <br/> <br/>
                <div className="form-check">
                    <input type="checkbox" className="form-check-input" id="exampleCheck1"/>
                    <label className="form-check-label" htmlFor="exampleCheck1">I agree to the terms and conditions.</label>
                </div>
                <br/> <br/>
                <button type="submit" className="btn btn-primary">Submit</button>
            </form>
        </div>
    );
}
