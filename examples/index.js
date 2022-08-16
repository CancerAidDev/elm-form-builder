import { Elm } from "./Main.elm";
import { registerComponent } from "@canceraiddev/phone-validator";

registerComponent();

Elm.Main.init({
  node: document.querySelector("main"),
});
