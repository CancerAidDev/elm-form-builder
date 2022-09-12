module Form.Validate.Required exposing (requiredValidator)

import Form.Validate.Types as ValidatorTypes


{-| Validator API for a value being required (non-empty).
-}
requiredValidator : ValidatorTypes.Validator
requiredValidator _ value =
    if String.isEmpty value then
        Err ValidatorTypes.RequiredError

    else
        Ok value
