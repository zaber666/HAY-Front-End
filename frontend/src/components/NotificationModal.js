import React from 'react'
import styles from "./newCss/Notification.module.css"
import {getToken, setToken, setIdType, setPersonId, setUsername, getIdType} from './Variables.js';
import { useEffect, useState } from 'react'
import Avatar from '@mui/material/Avatar';

const NotificationModal = ({notificationModalOff}) => {
    const[notificationList, setNotificationList] = useState([])

    useEffect( () => {
        const getResponse = async () => {
            // change here
            const notiFromServer = await fetchNotifications()

            const data = [
                {
                    "from":"Najibul Haque Sarker",
                    "text":"Your Request has been accepted",
                    "url":""
                },
                {
                    "from":"System",
                    "text":"Your Request has been denied",
                    "url":""
                },
                {
                    "from":"Iftekhar Hakim Kaowsar",
                    "text":"Your are dead",
                    "url":""
                },
                {
                    "from":"Apurba Saha",
                    "text":"Sent You a meassage",
                    "url":""
                },
                {
                    "from":"Apurba Saha",
                    "text":"Sent You a meassage",
                    "url":""
                },
                {
                    "from":"Apurba Saha",
                    "text":"Sent You a meassage",
                    "url":""
                },
                {
                    "from":"Apurba Saha",
                    "text":"Sent You a meassage",
                    "url":""
                },
                {
                    "from":"Apurba Saha",
                    "text":"Sent You a meassage",
                    "url":""
                },
                {
                    "from":"Apurba Saha",
                    "text":"Sent You a meassage",
                    "url":""
                },
                {
                    "from":"Apurba Saha",
                    "text":"Sent You a meassage",
                    "url":""
                },
                {
                    "from":"Apurba Saha",
                    "text":"Sent You a meassage",
                    "url":""
                },
                {
                    "from":"Apurba Saha",
                    "text":"Sent You a meassage",
                    "url":""
                },
                {
                    "from":"Apurba Saha",
                    "text":"Sent You a meassage",
                    "url":""
                },
            ]

            setNotificationList(data)
        }
        getResponse()

    }, [])

    const fetchNotifications = async () => {
        const res = await fetch('/view_verified_report', {method: "GET", headers: {'Accept': 'application/vnd.api+json'
                            , 'x-access-token': getToken()}})
        const data = await res.json()
        return data
    }




    return (
        <div className={styles.modalNoti}>
            <div onClick={notificationModalOff} className={styles.overlayNoti}></div>

            <div className={styles.modalContentNoti}>
                <div style={{height:"5px"}}></div>
                <div className={styles.notiHeader}>
                    <span style={{fontSize:"1.1rem"}}><b>Notifications</b></span>
                    <span onClick={notificationModalOff} style={{fontSize:"0.9rem", float:"right", textDecoration:"underline", cursor:"pointer"}}>Close</span>
                </div>

                <div className={styles.detailContainerNoti}>
                    <hr className={styles.linePsy}></hr>
                    {
                        notificationList.map(
                            (notification) => (
                                <>
                                    <div className={styles.eachNoti}>
                                        <div className={styles.leftNoti}>
                                            <Avatar sx={{border:1, borderColor:"black", bgcolor:"#329599"}}>{notification.from.charAt(0)}</Avatar>
                                        </div>

                                        <div className={styles.rightNoti}>
                                            <span>{notification.text}</span>
                                        </div>
                                    </div>

                                    <hr className={styles.linePsy}></hr>
                                </>
                            )
                        )
                    }
                </div>

            </div>
        </div>
    )
}

export default NotificationModal