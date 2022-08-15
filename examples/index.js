import { Elm } from "./Main.elm";
import { groupDigitsListener } from "./phone";

window.addEventListener(
  "input",
  function (event) {
    groupDigitsListener(event, "AU");
  },
  true
);

Elm.Main.init({
  node: document.querySelector("main"),
});
