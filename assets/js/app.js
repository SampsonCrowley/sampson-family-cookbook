// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"
import "polyfills"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"
const removeArrayElement = (target) => {
  let el = document.getElementById(target.dataset.id);
  let li = el.parentNode;
  li.parentNode.removeChild(li);
}

const addArrayElement = ({dataset}) => {
  let container = document.getElementById(dataset.container),
      index     = container.dataset.index,
      newRow    = dataset.prototype
  container.insertAdjacentHTML("beforeend", newRow.replace(/__name__/g, index))
  container.dataset.index = parseInt(container.dataset.index) + 1
}

const onClick = (ev) => {
  const target = ev.target
  if(target.classList.contains("remove-form-field")) return removeArrayElement(target)
  if(target.classList.contains("add-form-field")) return addArrayElement(target)
}

const setDuration = ({dataset: { id }}) => {
  const mainInput = document.getElementById(id),
        hours     = (+document.getElementById(`${id}_hours`).value) * 60 * 60,
        minutes   = (+document.getElementById(`${id}_minutes`).value) * 60,
        seconds   = (+document.getElementById(`${id}_seconds`).value),
        value     = hours + minutes + seconds
  if(+mainInput.value !== value) mainInput.value = value
}

const onInputChange = (ev) => {
  const target = ev.target
  if(target.classList.contains("duration-input")) return setDuration(target)
}

document.addEventListener("click", onClick)
document.addEventListener("change", onInputChange)

window.__socket = require("phoenix").Socket;
