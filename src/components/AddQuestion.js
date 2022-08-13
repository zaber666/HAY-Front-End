import React from 'react'
import "./AddQuestion.css"
import "./ShowResponse.css"
import {useState, useEffect} from "react";
import {FaPlus, FaTimes} from 'react-icons/fa'

const AddQuestion = () => {

    const [quesBody, setQuesBody] = useState("")
    const [options, setOptions] = useState([])
    const [addOptionWidget, setAddOptionWidget] = useState(false)
    const [newOptionText, setNewOptionText] = useState("")


    const newOptionAdded = () => {

        if(!newOptionText){
            alert("Option Field Empty")
            return
        }
        console.log(newOptionText)
        var index = 0;
        while( index < options.length){
            if(options[index] === newOptionText){
                alert("Option Already Exists. Try New one")
                index++
                return
            }
            index++;
        }
        options.push(newOptionText)
        setAddOptionWidget(false)
        setNewOptionText("")
    }

    const removeOption = (option) => {
        console.log(option)
        var filtered = options.filter(opt => opt !== option)
        setOptions(filtered)
    }

    const submit = () => {
        if(!quesBody){
            alert("Question Body is empty !!!")
            return
        }

        if(options.length < 1){
            alert("No Options Given")
            return
        }

        var response = {}
        response["quesBody"] = quesBody
        response["options"] = options
        console.log(response)

        //send response to backend
        
        setQuesBody("")
        setOptions([])


    }

    return (
        <div className='container'>
            <div >
                Request to Update Questionnaire of PTSD Test - Change This
            </div>
            <hr className='line-psy'></hr>

            <div className='section'>Add New Questions</div>
            <hr className='line-psy' style={{width:"30%"}}></hr>

            <div className='ques-body'>
                <label><b>Question Body</b></label> <br/><br/>
                <textarea style={{"resize":"None"}} rows="3" cols="70" placehodler="Enter Question Body" value={quesBody} onChange={(e) => {setQuesBody(e.target.value)}} />
                <br/><br/><br/>
            </div>


            <div className='options'>
                <label><b>Options</b></label> 

                <div>
                    <ul style={{"marginTop":"2%"}}>
                        {
                            options.map(
                                (option) => (
                                    <li style={{"fontSize":"1.1rem"}}>
                                        <div style={{"display":"flex"}}>
                                            <div style={{"marginRight":"2%"}}>
                                                {option}
                                            </div>
                                            <FaTimes className='cross' onClick={() => removeOption(option)}/>
                                        </div>
                                        
                                    </li>
                                )
                            )

                        }
                    </ul>
                </div>
                

                {
                    !addOptionWidget && (
                        <div className='add-new-option' onClick={() => {setAddOptionWidget(true); }}>
                            <FaPlus className='icn'/> <div>Add Option</div>
                        </div>
                    )
                }
                
            </div>

            {
                addOptionWidget && (
                    <div>
                        <label>Add New Option</label><br />
                        <input style={{"marginLeft":"0%", "width":"30%"}} type="text" placeholder="Enter Option" value={newOptionText} onChange={(e) => setNewOptionText(e.target.value)} />
                        
                        <div style={{"marginTop":"2%"}} className='saveNDcancel'>
                            <div className='save' onClick={() => newOptionAdded()}>
                                Save
                            </div>

                            <div className='cancel' onClick={() => {setAddOptionWidget(false); setNewOptionText("")}}>
                                Cancel
                            </div>
                        </div>
                    </div>
                )
            }

            <div className='done-btn' onClick={() => submit()}>
                Send
            </div>
        </div>
    )
}

export default AddQuestion