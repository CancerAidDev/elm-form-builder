import { Elm } from "./Main.elm";
import { groupDigitsListener } from "./phone";
import PhoneValidator from "./phone";

/*window.addEventListener(
  "input",
  function (event) {
    groupDigitsListener(event, "AU");
  },
  true
);*/

window.customElements.define("phone-validator", PhoneValidator);

Elm.Main.init({
  node: document.querySelector("main"),
});
