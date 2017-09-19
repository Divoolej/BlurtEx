// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"
import { Socket, Presence } from "phoenix"

let guardianToken = document.getElementById("guardian_token").innerText;

const user = document.getElementById("user").innerText
const socket = new Socket("/socket", { params: { guardian_token: guardianToken } })
socket.connect()

let presences = {}

const formattedTimestamp = timestamp => {
  const data = new Date(timestamp)
  return data.toLocaleString()
}

const listBy = (user, { metas }) => ({
  user,
  onlineAt: formattedTimestamp(metas[0].online_at)
})

const userList = document.getElementById("userList")
const render = presences => {
  userList.innerHTML = Presence.list(presences, listBy)
    .map(presence => `
      <li>
        ${presence.user}
        <br>
        <small>online since ${presence.onlineAt}</small>
      </li>
    `)
    .join("")
}

const room = socket.channel("room:lobby")
room.on("presence_state", state => {
  presences = Presence.syncState(presences, state)
  render(presences)
})

room.on("presence_diff", diff => {
  presences = Presence.syncDiff(presences, diff)
  render(presences)
})

room.join()

const messageInput = document.getElementById("newMessage")
messageInput.addEventListener("keypress", e => {
  if (e.keyCode == 13 && messageInput.value != "") {
    room.push("message:new", messageInput.value)
    messageInput.value = ""
  }
})

const messageList = document.getElementById("messageList")
const renderMessage = message => {
  const messageElement = document.createElement("li")
  messageElement.innerHTML = `
    <b>${message.user}</b>
    <i>${formattedTimestamp(message.timestamp)}</i>
    <p>${message.body}</p>
  `
  messageList.appendChild(messageElement)
  messageList.scrollTop = messageList.scrollHeight
}

room.on("message:new", message => renderMessage(message))
