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
