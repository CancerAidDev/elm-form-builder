module Form.Validate.Options exposing (optionsValidator, remoteOptionsValidator)

import Form.Field as Field
import Form.Field.Option as Option
import Form.Locale as Locale
import Form.Validate.Types as ValidatorTypes exposing (StringFieldError)
import RemoteData


{-| Validator API for a value being in a list of options.
-}
optionsValidator : List Option.Option -> ValidatorTypes.Validator
optionsValidator options _ field =
    let
        value =
            Field.getStringValue_ field
    in
    if List.map .value options |> List.member value then
        Ok field

    else
        Err (ValidatorTypes.InvalidOption field)


{-| Validator API for a value being in a list of remote (retrieved via network) options.
-}
remoteOptionsValidator : RemoteData.RemoteData err (List Option.Option) -> ValidatorTypes.Validator
remoteOptionsValidator remoteOptions locale value =
    RemoteData.map (\o -> optionsValidator o locale value) remoteOptions
        |> RemoteData.withDefault (Err ValidatorTypes.InvalidOption)
