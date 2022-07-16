import React from 'react'
import "./Tests.css"

const Test = ({key, test, description}) => {
  return (
    <div>
        <div className="test-name">{test}</div>
        <div class="test-desc">{description}</div>
    </div>
  )
}

export default Test