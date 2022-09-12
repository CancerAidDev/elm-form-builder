module Form.Validate.Required exposing (requiredValidator)

import Form.Field as Field
import Form.Validate.Types as ValidatorTypes


{-| Validator API for a value being required (non-empty).
-}
requiredValidator : ValidatorTypes.Validator
requiredValidator _ field =
    let
        trimmed =
            String.trim (Field.getStringValue_ field)
    in
    if String.isEmpty trimmed then
        Err (ValidatorTypes.RequiredError field)

    else
        Ok field
