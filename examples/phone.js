const CLEAN_REGEX = /[\s|\D]/g;

function clean(str) {
  return str.replace(CLEAN_REGEX, "");
}

function getNumberLength(countryCode) {
  switch (countryCode) {
    case "NZ":
      return 10;
    case "US":
      return 10;
    case "AU":
      return 9;
    default:
      return 12;
  }
}

function getGroupRegex(countryCode) {
  switch (countryCode) {
    case "NZ":
      return new RegExp(`(.{0,2})(.{0,3})(.{0,5})`);
    case "US":
      return new RegExp(`(.{0,3})(.{0,3})(.{0,4})`);
    case "AU":
      return new RegExp(`(.{0,3})(.{0,3})(.{0,4})`);
    default:
      return new RegExp("(.*)");
  }
}

function trim(str, countryCode) {
  return str.slice(0, getNumberLength(countryCode));
}

function groupDigits(str, countryCode) {
  return (
    trim(clean(str), countryCode)
      .match(getGroupRegex(countryCode))
      .splice(1)
      .filter((n) => n)
      .join(" ") ?? ""
  );
}

// Group digits and set correct cursor location in tel input. If we have elm modify
// the input value it always sets the cursor to the end of the string. Using js we
// can group the digits and work out where the cursor should be and set it using this
// function.
export function groupDigitsListener(event, countryCode) {
  const target = event.target;
  if (target.type === "tel" && target.id !== "phoneUniversal") {
    let c = countryCode;
    if (target.id.includes("phoneUniversal")) {
      c = target.id.split("-")[1];
    }
    const start = target.selectionStart ?? undefined;
    const before = target.value.slice(0, start);
    const after = target.value.slice(start);
    const beforeGrouped = groupDigits(before, c);
    target.value = groupDigits(before + after, c);
    target.selectionStart = target.selectionEnd = beforeGrouped.length;
  }
  if (target.id === "phoneUniversal") {
    target.value = trim(target.value);
  }
}
