import { Elm } from "./Main.elm";
// still need to import - is it possible to import in other codebases
import "../src/Form/Lib/PhoneValidator";

Elm.Main.init({
  node: document.querySelector("main"),
});
