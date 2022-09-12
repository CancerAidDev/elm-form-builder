module Form.Validate.Options exposing (optionsValidator, remoteOptionsValidator)

import Form.Field.Option as Option
import Form.Locale exposing (Locale)
import Form.Validate.Types as ValidatorTypes
import RemoteData


optionsValidator : List Option.Option -> Locale -> String -> Result ValidatorTypes.StringError String
optionsValidator options _ value =
    if List.map .value options |> List.member value then
        Ok value

    else
        Err ValidatorTypes.InvalidOption


remoteOptionsValidator : RemoteData.RemoteData err (List Option.Option) -> Locale -> String -> Result ValidatorTypes.StringError String
remoteOptionsValidator remoteOptions locale value =
    RemoteData.map (\o -> optionsValidator o locale value) remoteOptions
        |> RemoteData.withDefault (Err ValidatorTypes.InvalidOption)
