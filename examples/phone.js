// moved to npm package and imported in index.js

class PhoneValidator extends HTMLElement {
  constructor() {
    const self = super();
    self._countryCode = null;
  }

  connectedCallback() {
    window.addEventListener("input", this.groupDigitsListener, true);
  }

  set countryCode(code) {
    self._countryCode = code;
  }

  // Group digits and set correct cursor location in tel input. If we have elm modify
  // the input value it always sets the cursor to the end of the string. Using js we
  // can group the digits and work out where the cursor should be and set it using this
  // function.
  groupDigitsListener = (event) => {
    const target = event.target;
    if (target.type === "tel") {
      const start = target.selectionStart ?? undefined;
      const before = target.value.slice(0, start);
      const after = target.value.slice(start);
      const beforeGrouped = this.groupDigits(before);
      target.value = this.groupDigits(before + after);
      target.selectionStart = target.selectionEnd = beforeGrouped.length;
    }
  };

  clean(str) {
    return str.replace(/[\s|\D]/g, "");
  }

  getNumberLength() {
    switch (self._countryCode) {
      case "NZ":
        return 10;
      case "US":
        return 10;
      default:
        return 9;
    }
  }

  getGroupRegex() {
    switch (self._countryCode) {
      case "NZ":
        return new RegExp(`(.{0,2})(.{0,3})(.{0,5})`);
      case "US":
        return new RegExp(`(.{0,3})(.{0,3})(.{0,4})`);
      default:
        return new RegExp(`(.{0,3})(.{0,3})(.{0,3})`);
    }
  }

  trim(str) {
    return str.slice(0, this.getNumberLength(self._countryCode));
  }

  groupDigits(str) {
    return (
      this.trim(this.clean(str), self._countryCode)
        .match(this.getGroupRegex(self._countryCode))
        .splice(1)
        .filter((n) => n)
        .join(" ") ?? ""
    );
  }
}

export function registerComponent() {
  window.customElements.define("phone-validator", PhoneValidator);
}
