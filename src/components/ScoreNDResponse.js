import React from 'react'
import "./ScoreNDResponse"



{/* <table class="content-table">
    <thead>
        <tr>
        <th>Test Name</th>
        <th>Patient Name</th>
        <th>System Score</th>
        <th>Response</th>
        {% comment %} <th>Suggest Psychiatrists</th>
        <th>Disorder</th> {% endcomment %}
        </tr>
    </thead>
    <tbody>

        {% for testresult in testresults%}
        <tr>
            <td>{{testresult.test.name}}</td>
            <td>{{testresult.patient.name}}</td>
            <td>{{testresult.sum_score}}</td>
            <td> <span class="table-elem" onclick="location.href='{% url 'psychiatrists:test_result_varify' testresult.id %}'">Show Response</span> </td>
        </tr>
        {% endfor %}

        {% comment %} <tr>
        <td>Audrey McKinney</td>
        <td>PSTD Positive</td>
        <td> <span class="table-elem">Show Response</span> </td>
        <td> <span class="table-elem">Suggest</span> </td>
        <td> <span class="table-elem">Add</span> </td>
        </tr>
        <tr>
        <td>Stella Warren</td>
        <td>PSTD Negative</td>
        <td> <span class="table-elem">Show Response</span> </td>
        <td> <span class="table-elem">Suggest</span> </td>
        <td> <span class="table-elem">Add</span> </td>
        </tr>
        <tr>
        <td>Jon Doe</td>
        <td>PSTD Positive</td>
        <td> <span class="table-elem">Show Response</span> </td>
        <td> <span class="table-elem">Suggest</span> </td>
        <td> <span class="table-elem">Add</span> </td>
        </tr>
        <tr>
        <td>Brian Smith</td>
        <td>PSTD Negative</td>
        <td> <span class="table-elem">Show Response</span> </td>
        <td> <span class="table-elem">Suggest</span> </td>
        <td> <span class="table-elem">Add</span> </td>
        </tr> {% endcomment %}
    </tbody>
</table> */}

const ScoreNDResponse = () => {
  return (
    <div>ScoreNDResponse</div>
  )
}

export default ScoreNDResponse