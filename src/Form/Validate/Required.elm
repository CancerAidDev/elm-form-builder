module Form.Validate.Required exposing (requiredValidator)

import Form.Validate.Types as ValidatorTypes


requiredValidator : ValidatorTypes.Validator
requiredValidator _ value =
    if String.isEmpty value then
        Err ValidatorTypes.RequiredError

    else
        Ok value
