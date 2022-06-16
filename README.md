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

## Doing a release

When your changes are ready to go (merged into main) it's time to do a release.

1. elm bump: `yarn run elm bump`. Fix any issues this finds and accept recommended version suggestion.
2. Check elm publish works: `yarn run elm publish`. It will fail when it gets to the github tag stage but might show some other suggestions / issues.
3. 
Merge change
elm publish for real
