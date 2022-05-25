# elm-form-builder

Form widgets and validation used for internal projects.

HTML elements are styled using [Bulma](https://bulma.io).

Currently supports the following form elements:

- Age
- Checkbox
- Date
- Email
- Phone
- Radio
- Select
- Text

## Examples

We recommend checking out the [examples] ([code]) to get a feel for how it works.

[examples]: https://canceraiddev.github.io/elm-form-builder/
[code]: https://github.com/canceraiddev/elm-form-builder/tree/main/examples

Run the following commands to test out the examples locally:

```
yarn install
yarn start
```

## Setup

```
yarn install
```

## CI

```
yarn elm-format --validate src tests
yarn elm-review
yarn elm-test
yarn elm make
```
